"""
Convert DOCX to Typst (.typ) format for manual editing before PDF generation

This script:
1. Converts EMF/WMF images to PNG
2. Converts DOCX to Typst format using Pandoc
3. Optimizes images (reduces file size)
4. Optionally applies post-processing to clean up the Typst output
5. Outputs a .typ file that can be manually edited

Usage:
    python convert_docx_to_typst.py [input.docx] [output.typ]
"""
import subprocess
import sys
from pathlib import Path
import re
from PIL import Image
import os

def convert_doc_to_docx(doc_path):
    """Convert .doc to .docx using Word COM automation"""
    doc_path = Path(doc_path)
    docx_path = doc_path.parent / f"{doc_path.stem}.docx"

    if docx_path.exists():
        print(f"   [OK] DOCX already exists: {docx_path.name}")
        return docx_path

    print(f"   Converting {doc_path.suffix} to .docx...")

    # Create PowerShell script
    ps_script = f"""
$docPath = "{doc_path.absolute()}"
$docxPath = "{docx_path.absolute()}"

$Word = New-Object -ComObject Word.Application
$Word.Visible = $false

$Doc = $Word.Documents.Open($docPath)
$Doc.SaveAs([ref]$docxPath, [ref]16)
$Doc.Close()
$Word.Quit()

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Word) | Out-Null
"""

    ps_file = doc_path.parent / "convert_temp.ps1"
    ps_file.write_text(ps_script, encoding='utf-8')

    try:
        result = subprocess.run(
            ['powershell', '-ExecutionPolicy', 'Bypass', '-File', str(ps_file)],
            capture_output=True,
            text=True,
            timeout=60
        )

        ps_file.unlink()  # Clean up temp file

        if result.returncode == 0 and docx_path.exists():
            print(f"   [OK] Converted to: {docx_path.name}")
            return docx_path
        else:
            print(f"   [ERROR] Conversion failed: {result.stderr}")
            return None
    except Exception as e:
        print(f"   [ERROR] Could not convert: {e}")
        if ps_file.exists():
            ps_file.unlink()
        return None

def optimize_images(media_path, quality=85, max_width=2000, create_backup=True):
    """
    Optimize images in the media folder to reduce file size

    Args:
        media_path: Path to the media folder containing images
        quality: JPEG quality (1-100, default 85)
        max_width: Maximum width in pixels (default 2000, keeps aspect ratio)
        create_backup: Whether to backup original images (default True)

    Returns:
        Dictionary with optimization statistics
    """
    media_path = Path(media_path)

    if not media_path.exists():
        return {"status": "error", "message": "Media folder not found"}

    # Create backup folder for original images
    backup_path = None
    if create_backup:
        backup_path = media_path / 'originals'
        backup_path.mkdir(exist_ok=True)

    stats = {
        "processed": 0,
        "original_size": 0,
        "optimized_size": 0,
        "backed_up": 0,
        "files": []
    }

    # Supported image formats
    image_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff'}

    for img_file in media_path.iterdir():
        if img_file.suffix.lower() not in image_extensions:
            continue

        try:
            # Get original file size
            original_size = img_file.stat().st_size
            stats["original_size"] += original_size

            # Backup original file if requested
            if backup_path:
                import shutil
                backup_file = backup_path / img_file.name
                if not backup_file.exists():  # Only backup if not already backed up
                    shutil.copy2(img_file, backup_file)
                    stats["backed_up"] += 1

            # Open and optimize image
            with Image.open(img_file) as img:
                # Preserve EXIF data and orientation
                exif = img.info.get('exif', None)

                # Apply EXIF orientation if present
                try:
                    from PIL import ImageOps
                    img = ImageOps.exif_transpose(img)
                except Exception:
                    pass  # If exif_transpose fails, continue without it

                # Convert RGBA to RGB for JPEG
                if img.mode in ('RGBA', 'LA', 'P'):
                    # Create white background
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    if img.mode == 'P':
                        img = img.convert('RGBA')
                    background.paste(img, mask=img.split()[-1] if img.mode in ('RGBA', 'LA') else None)
                    img = background
                elif img.mode != 'RGB':
                    img = img.convert('RGB')

                # Resize if too large
                if img.width > max_width:
                    ratio = max_width / img.width
                    new_height = int(img.height * ratio)
                    img = img.resize((max_width, new_height), Image.Resampling.LANCZOS)

                # Determine output format and settings
                save_kwargs = {'quality': quality, 'optimize': True}
                if exif:
                    save_kwargs['exif'] = exif

                if img_file.suffix.lower() in {'.jpg', '.jpeg'}:
                    # Save as optimized JPEG with EXIF
                    img.save(img_file, 'JPEG', **save_kwargs)
                elif img_file.suffix.lower() == '.png':
                    # Convert PNG to JPEG for better compression (if no transparency)
                    jpeg_path = img_file.with_suffix('.jpg')
                    img.save(jpeg_path, 'JPEG', **save_kwargs)

                    # Remove original PNG if JPEG is smaller
                    jpeg_size = jpeg_path.stat().st_size
                    if jpeg_size < original_size:
                        img_file.unlink()
                        img_file = jpeg_path
                    else:
                        # Keep PNG, delete JPEG
                        jpeg_path.unlink()
                else:
                    # For other formats, convert to JPEG
                    jpeg_path = img_file.with_suffix('.jpg')
                    img.save(jpeg_path, 'JPEG', **save_kwargs)
                    img_file.unlink()
                    img_file = jpeg_path

            # Get optimized file size
            optimized_size = img_file.stat().st_size
            stats["optimized_size"] += optimized_size
            stats["processed"] += 1

            # Calculate reduction
            reduction = ((original_size - optimized_size) / original_size * 100) if original_size > 0 else 0

            stats["files"].append({
                "name": img_file.name,
                "original": original_size,
                "optimized": optimized_size,
                "reduction": reduction
            })

        except Exception as e:
            print(f"   [WARNING] Could not optimize {img_file.name}: {e}")

    return stats

def convert_docx_to_typst(docx_path, typst_path=None, apply_template=True):
    """
    Convert DOCX (or DOC) to Typst format with full post-processing

    Args:
        docx_path: Path to input DOCX/DOC file
        typst_path: Path to output .typ file (optional)
        apply_template: Whether to apply article-from-docx.typ template
    """
    docx_path = Path(docx_path)

    if not docx_path.exists():
        print(f"Error: File not found: {docx_path}")
        return False

    # Step 0: Convert .doc to .docx if needed
    if docx_path.suffix.lower() == '.doc':
        print("\n0. Converting .doc to .docx...")
        docx_path = convert_doc_to_docx(docx_path)
        if docx_path is None:
            return False

    # Default output path
    if typst_path is None:
        typst_path = docx_path.parent / f"{docx_path.stem}.typ"
    else:
        typst_path = Path(typst_path)

    print(f"Converting: {docx_path.name}")
    print(f"Output: {typst_path.name}")
    print("="*60)

    # Check if DOCX contains EMF/WMF images
    print("\n1. Preparing document...")

    # Use the original DOCX directly - image conversion will happen after Pandoc extraction
    source_docx = docx_path
    print(f"   [OK] Using document: {source_docx.name}")

    # Convert to Typst using Pandoc
    print(f"\n2. Converting to Typst format...")

    # Build Pandoc command
    pandoc_cmd = [
        'pandoc',
        str(source_docx),
        '-f', 'docx',
        '-t', 'typst',
        '-o', str(typst_path),
        '--extract-media=.',
    ]

    # Check for optional Typst template in same directory as DOCX
    if apply_template:
        # Look for template in the same directory as the input DOCX
        template_path = docx_path.parent / 'article-from-docx.typ'
        if template_path.exists():
            pandoc_cmd.extend(['--template', str(template_path)])
            print(f"   [OK] Using template: {template_path.name}")
        else:
            print(f"   [INFO] No template found - using built-in formatting")
            print(f"         (Looked for: {template_path.name})")

    # Add metadata
    pandoc_cmd.extend([
        '-V', 'lang=fr',
        '-V', 'fontsize=11pt',
        '-V', 'mainfont=Atkinson Hyperlegible',
    ])

    try:
        result = subprocess.run(
            pandoc_cmd,
            capture_output=True,
            text=True,
            timeout=180
        )

        if result.returncode != 0:
            print(f"   [ERROR] Pandoc conversion failed:")
            print(f"   {result.stderr}")
            return False

        if result.stderr:
            # Print warnings but continue
            warnings = result.stderr.strip().split('\n')
            print(f"   [WARNINGS] {len(warnings)} warning(s):")
            for warning in warnings[:5]:  # Show first 5 warnings
                print(f"      {warning[:80]}")
            if len(warnings) > 5:
                print(f"      ... and {len(warnings)-5} more warnings")

        print(f"   [OK] Typst file created: {typst_path}")

    except subprocess.TimeoutExpired:
        print(f"   [ERROR] Conversion timed out after 3 minutes")
        return False
    except Exception as e:
        print(f"   [ERROR] Conversion failed: {e}")
        return False

    # Optimize images in media folder
    print(f"\n3. Optimizing images...")
    media_path = docx_path.parent / 'media'
    png_to_jpg_conversions = []  # Track PNG→JPG conversions

    if media_path.exists():
        try:
            stats = optimize_images(media_path, quality=85, max_width=2000)

            if stats["processed"] > 0:
                total_reduction = ((stats["original_size"] - stats["optimized_size"]) /
                                 stats["original_size"] * 100) if stats["original_size"] > 0 else 0

                print(f"   [OK] Optimized {stats['processed']} image(s)")
                print(f"      Original size: {stats['original_size'] / 1024:.1f} KB")
                print(f"      Optimized size: {stats['optimized_size'] / 1024:.1f} KB")
                print(f"      Reduction: {total_reduction:.1f}%")

                if stats["backed_up"] > 0:
                    print(f"      Backed up {stats['backed_up']} original(s) to media/originals/")

                # Track PNG to JPG conversions for later path updates
                for file_info in stats["files"]:
                    if file_info["name"].endswith('.jpg'):
                        # Check if there was a .png backup
                        png_name = file_info["name"].replace('.jpg', '.png')
                        if (media_path / 'originals' / png_name).exists():
                            png_to_jpg_conversions.append((png_name, file_info["name"]))

                # Show top 3 files by reduction
                if len(stats["files"]) > 0:
                    sorted_files = sorted(stats["files"], key=lambda x: x["reduction"], reverse=True)
                    print(f"      Top reductions:")
                    for file_info in sorted_files[:3]:
                        print(f"         {file_info['name']}: {file_info['reduction']:.1f}% smaller")
            else:
                print(f"   [INFO] No images to optimize")

        except Exception as e:
            print(f"   [WARNING] Image optimization failed: {e}")
    else:
        print(f"   [INFO] No media folder found, skipping optimization")

    # Post-process the Typst file
    print(f"\n4. Post-processing Typst file...")

    if not typst_path.exists():
        print(f"   [ERROR] Output file not created")
        return False

    try:
        content = typst_path.read_text(encoding='utf-8')
        original_size = len(content)

        # Extract document title from filename
        doc_title = docx_path.stem.replace('_', ' ').replace('-', ' ').title()
        doc_filename = docx_path.stem

        # Apply fixes
        content = post_process_typst(content, doc_title=doc_title, doc_filename=doc_filename)

        # Fix math formulas (convert #sub[] and #super[] to _ and ^)
        content = fix_math_subscripts_superscripts(content)

        # Update PNG→JPG paths in content if conversions occurred
        png_jpg_count = 0
        if png_to_jpg_conversions:
            for png_name, jpg_name in png_to_jpg_conversions:
                # Replace .png with .jpg in image paths
                # Handle various path formats: "./media/image.png", "media/image.png", "/media/image.png"
                content = content.replace(f'"./media/{png_name}"', f'"media/{jpg_name}"')
                content = content.replace(f'"media/{png_name}"', f'"media/{jpg_name}"')
                content = content.replace(f'"/media/{png_name}"', f'"media/{jpg_name}"')
                # Also handle uppercase .PNG
                content = content.replace(f'"./media/{png_name.replace(".png", ".PNG")}"', f'"media/{jpg_name}"')
                content = content.replace(f'"media/{png_name.replace(".png", ".PNG")}"', f'"media/{jpg_name}"')
            png_jpg_count = len(png_to_jpg_conversions)

        # WRITE FILE FIRST before any prints that might fail
        new_size = len(content)
        typst_path.write_text(content, encoding='utf-8')

        # Now safe to print (if these fail, file is already saved)
        print(f"      Fixed math notation (#sub[] to _, #super[] to ^)")
        if png_jpg_count > 0:
            print(f"      Updated {png_jpg_count} PNG to JPG path(s)")
        print(f"   [OK] Post-processing complete")
        print(f"      Original size: {original_size:,} characters")
        print(f"      New size: {new_size:,} characters")

    except UnicodeEncodeError as e:
        print(f"   [WARNING] Post-processing display error (file was saved correctly): {str(e)[:100]}")
        print(f"   The post-processed Typst output is available")
    except Exception as e:
        print(f"   [WARNING] Post-processing failed: {e}")
        print(f"   The original Typst output is still available")

    # Automatically compile to PDF
    print(f"\n6. Compiling to PDF...")
    pdf_path = typst_path.with_suffix('.pdf')

    try:
        result = subprocess.run(
            ['typst', 'compile', str(typst_path), str(pdf_path)],
            capture_output=True,
            text=True,
            timeout=60,
            cwd=typst_path.parent
        )

        if result.returncode == 0:
            print(f"   [OK] PDF created: {pdf_path.name}")
            pdf_size = pdf_path.stat().st_size / 1024 / 1024
            print(f"   PDF size: {pdf_size:.2f} MB")
        else:
            print(f"   [ERROR] PDF compilation failed:")
            print(f"   {result.stderr[:500]}")
            print(f"\n   You can compile manually with:")
            print(f"   typst compile {typst_path.name}")

    except FileNotFoundError:
        print(f"   [ERROR] Typst compiler not found")
        print(f"   Please install Typst: https://github.com/typst/typst")
        print(f"\n   Or compile manually with:")
        print(f"   typst compile {typst_path.name}")
    except subprocess.TimeoutExpired:
        print(f"   [ERROR] PDF compilation timed out")
        print(f"   The Typst file may be too large or complex")
    except Exception as e:
        print(f"   [WARNING] Could not compile PDF: {e}")
        print(f"\n   You can compile manually with:")
        print(f"   typst compile {typst_path.name}")

    # Generate summary
    print(f"\n" + "="*60)
    print(f"SUCCESS! Conversion complete")
    print(f"\nGenerated files:")
    print(f"  • Typst source: {typst_path.name}")
    if pdf_path.exists():
        print(f"  • PDF output:   {pdf_path.name}")
    print(f"\nNext steps:")
    print(f"1. Review the PDF: {pdf_path.name if pdf_path.exists() else typst_path.stem + '.pdf'}")
    print(f"2. Edit the .typ file if needed:")
    print(f"   - Fix any conversion issues")
    print(f"   - Adjust formatting")
    print(f"3. Recompile after edits:")
    print(f"   typst compile {typst_path.name}")

    return True

def post_process_typst(content, doc_title="Document", doc_filename="document"):
    """
    Apply post-processing fixes to Typst content

    Common fixes:
    - Add Typst metadata header (document info, settings)
    - Fix image syntax: remove #box(), use proper #image() or #figure()
    - Simplify image syntax (remove explicit dimensions, use width: 90%)
    - Fix figure/caption structure
    - Replace .emf/.wmf with .png
    - Clean up whitespace
    - Add outline and pagebreaks
    - Remove SOMMAIRE links
    """

    # Add Typst metadata header
    header = f"""// Document converti depuis DOCX avec Pandoc
// Post-traité pour Typst

// Métadonnées du document
#set document(
  title: "{doc_title}",
  author: "Auteur",
  date: datetime.today()
)

// Configuration de la page (A4, marges automatiques, français)
#set page(
  paper: "a4",
  margin: auto,
  header: align(right)[
    #text(size: 9pt, fill: gray)[{doc_filename}.pdf]
  ],
  footer: align(center)[
    #context [
      #text(size: 9pt)[
        #counter(page).display("1/1", both: true)
      ]
    ]
  ]
)

// Configuration du texte (Atkinson Hyperlegible prioritaire, Arial et polices actuelles en fallback, 11pt)
#set text(
  font: ("Atkinson Hyperlegible", "Arial", "Liberation Sans", "DejaVu Sans"),
  size: 11pt,
  lang: "fr",
  region: "FR"
)

// Configuration des paragraphes
#set par(
  justify: true,
  first-line-indent: 0pt
)

// Configuration de la numérotation des sections (1, 1.1, 1.1.1, 1.1.1.a)
#set heading(numbering: "1.1.1.a")

// Configuration des titres
#show heading.where(level: 1): set text(size: 18pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")

// Configuration des liens
#show link: set text(fill: blue)
#show link: underline

"""

    if not content.startswith('//'):
        content = header + content
    
    # Ensure margin: auto is always present (fix for corrupted headers)
    content = re.sub(r'margin:\s*\n', r'margin: auto,\n', content)
    content = re.sub(r'margin:\s*$', r'margin: auto,', content, flags=re.MULTILINE)

    # Fix figure/image syntax from Pandoc output
    # Pandoc often generates: #box(image("./media/image5.jpeg", height: 3.54167in, width: 4.23958in))
    # We want: image("media/image5.jpeg", width: 80%) for standalone images
    # Or: #figure(image("media/image2.png", width: 80%), caption: [...]) with captions

    # Pattern 1: Remove #box() wrapper and fix path (remove leading ./ and /)
    # Convert exact dimensions (height: X, width: Y) to width: 80%
    # #box(image("./media/image5.jpeg", height: 3.54167in, width: 4.23958in)) -> image("media/image5.jpeg", width: 80%)
    # Match: #box(image("./media/..." or "./media/..." or "/media/..." or "media/..."
    content = re.sub(
        r'#box\(image\("(?:\./|/|)(media/[^"]+)"(?:,\s*(?:height|width):\s*[^,)]+)+\)\)',
        r'image("\1", width: 80%)',
        content
    )

    # Also handle #box(image(...)) without dimensions
    content = re.sub(
        r'#box\(image\("(?:\./|/|)(media/[^"]+)"\)\)',
        r'image("\1", width: 80%)',
        content
    )

    # Fix paths: remove leading / from /media/ to make them relative
    content = re.sub(r'image\("/media/', r'image("media/', content)

    # Pattern 2: Fix standalone image() calls - remove ./ prefix and normalize to width: 80%
    # image("./media/image.jpg", height: 3.54in, width: 4.23in) -> image("media/image.jpg", width: 80%)
    # image("./media/image.jpg") -> image("media/image.jpg", width: 80%)
    content = re.sub(
        r'(?<!#)image\("\.?/?([^"]+)"(?:,\s*(?:height|width):\s*[^,)]+)*\)',
        r'image("\1", width: 80%)',
        content
    )

    # Pattern 3: Fix image paths that already have # but wrong format
    # #image("./media/image.jpg", height: 2.5in, width: 3.0in) -> image("media/image.jpg", width: 80%)
    # #image("media/image.jpg", height: 500pt) -> image("media/image.jpg", width: 80%)
    content = re.sub(
        r'#image\("\.?/?([^"]+)"(?:,\s*(?:height|width):\s*[^,)]+)*\)',
        r'image("\1", width: 80%)',
        content
    )

    # Pattern 4: Fix figure structure with brackets
    # #figure([image(...)], caption: ...) -> #figure(image(...), caption: ...)
    content = re.sub(
        r'#figure\(\[(image\([^)]+\))\]',
        r'#figure(\1',
        content
    )

    # Pattern 5: Normalize figure width to 80% and clean up paths
    # #figure(image("./media/image.jpg", height: 2in, width: 3in)) -> #figure(image("media/image.jpg", width: 80%))
    content = re.sub(
        r'#figure\(image\("\.?/?([^"]+)"(?:,\s*(?:height|width):\s*[^,)]+)*\)',
        r'#figure(image("\1", width: 80%)',
        content
    )

    # Pattern 6: Format figures with captions for readability
    # Make figures more readable by adding newlines and removing #emph wrappers
    def format_figure(match):
        path = match.group(1)
        caption_content = match.group(2).strip()

        # Remove #emph wrapper from caption content
        caption_content = re.sub(r'#emph\[([^\]]+)\]', r'\1', caption_content)
        # Remove #strong wrapper from caption content
        caption_content = re.sub(r'#strong\[([^\]]+)\]', r'\1', caption_content)

        return f'#figure(\n  image("{path}", width: 80%),\n  caption: [{caption_content}]\n)'

    content = re.sub(
        r'#figure\(image\("([^"]+)",\s*width:\s*80%\),\s*caption:\s*\[([^\]]+(?:\[[^\]]*\][^\]]*)*)\]\)',
        format_figure,
        content,
        flags=re.DOTALL
    )

    # Pattern 5: Clean up any remaining nested #emph in captions
    # This handles cases where the above didn't catch everything
    # Look for caption: [ ... #emph[text] ... ]
    def clean_caption_emph(match):
        prefix = match.group(1)
        caption_content = match.group(2)
        # Remove all #emph wrappers
        caption_content = re.sub(r'#emph\[([^\]]+)\]', r'\1', caption_content)
        return f'{prefix}[{caption_content}]'

    content = re.sub(
        r'(caption:\s*)\[([^\]]+(?:#emph\[[^\]]+\])+[^\]]*)\]',
        clean_caption_emph,
        content
    )

    # Remove #emph[] and #strong[] wrappers comprehensively
    # These are unnecessary formatting that Pandoc adds excessively

    # Pattern 1: In table cells - table.cell(...)[#emph[text]] -> table.cell(...)[text]
    content = re.sub(r'\[#emph\[([^\]]+)\];?\]', r'[\1]', content)
    content = re.sub(r'\[#strong\[([^\]]+)\];?\]', r'[\1]', content)

    # Pattern 2: Standalone with semicolon - #emph[text]; -> text
    content = re.sub(r'#emph\[([^\]]+)\];', r'\1', content)
    content = re.sub(r'#strong\[([^\]]+)\];', r'\1', content)

    # Pattern 3: In content (recursive to handle nested cases)
    # Keep #emph and #strong when they're used for actual emphasis
    # But remove excessive wrapping in lists and tables
    # Only remove if inside table cells, lists, or excessive nesting
    def clean_excessive_emph(text):
        # Remove #emph[] around single lines in table cells or list items
        text = re.sub(r'(\+\s+.*?)#emph\[([^\]]+)\]', r'\1\2', text)
        # Remove from table cells that start with #emph
        text = re.sub(r'(\s+\[)\s*#emph\[([^\]]+)\](\s*\],?)', r'\1\2\3', text)
        return text

    content = clean_excessive_emph(content)

    # Pattern 6: Fix standalone images followed by #emph captions
    # Sometimes Pandoc generates:
    # image("path", width: 80%)
    #
    # #emph[Figure X - Caption text]
    # This should be: #figure(image("path", width: 80%), caption: [Figure X - Caption text])
    def fix_standalone_image(match):
        image_call = match.group(1)
        caption_text = match.group(2)
        # Remove #emph wrapper
        caption_text = re.sub(r'^#emph\[', '', caption_text)
        caption_text = re.sub(r'\]$', '', caption_text)
        return f'#figure({image_call},\n  caption: [\n    {caption_text}\n  ]\n)'

    content = re.sub(
        r'^(image\("[^"]+", width: 80%\))\n\n(#emph\[Figure [^\]]+\])',
        fix_standalone_image,
        content,
        flags=re.MULTILINE
    )

    # Fix common image path issues
    # Replace .emf and .wmf references with .png
    content = re.sub(r'image\("([^"]+)\.emf"', r'image("\1.png"', content)
    content = re.sub(r'image\("([^"]+)\.wmf"', r'image("\1.png"', content)
    content = re.sub(r'image\("([^"]+)\.gif"', r'image("\1.png"', content)

    # CRITICAL FIX: Remove # prefix from #image() when inside #figure()
    # This must be done BEFORE other image processing patterns
    # Images inside #figure() should be image(...), not #image(...)
    # Handle all variations with different whitespace patterns

    # Pattern 1: Same line - #figure(#image(
    content = re.sub(r'#figure\(\s*#image\(', r'#figure(image(', content)

    # Pattern 2: Next line with indentation - #figure(\n  #image(
    content = re.sub(r'#figure\(\s*\n\s+#image\(', r'#figure(\n  image(', content)

    # Pattern 3: With whitespace but same line - #figure(  #image(
    content = re.sub(r'#figure\(\s+#image\(', r'#figure(image(', content)

    # Pattern 4: Nested in align or other wrappers - align(...)[#table(...#image(
    # This catches #image inside table cells within figures
    content = re.sub(r'(\[|,)\s*#image\(', r'\1image(', content)
    
    # Fix malformed captions with \] escape sequences
    # Pattern: caption: [text, \] -> caption: [text]
    content = re.sub(r'caption:\s*\[([^\]]*),?\s*\\\]', r'caption: [\1]', content)

    # Fix double closing brackets in captions - caption: [text]]
    # This commonly occurs when Pandoc incorrectly formats figure captions
    content = re.sub(r'(caption:\s*\[[^\]]+)\]\]', r'\1]', content)

    # Fix unclosed caption brackets - if we have caption: [text without closing ]
    # This is a safety net for malformed captions
    def fix_unclosed_caption(match):
        caption_text = match.group(1)
        # Remove any trailing \] escapes
        caption_text = re.sub(r'\\\]\s*$', '', caption_text)
        # Remove trailing commas
        caption_text = caption_text.rstrip(', ')
        return f'caption: [{caption_text}]'

    # Match caption: [text that might be malformed
    content = re.sub(r'caption:\s*\[([^\]]*(?:\\\][^\]]*)*)', fix_unclosed_caption, content)

    # IMPORTANT: Handle image+caption wrapping BEFORE adding # prefix to standalone images
    # This ensures images inside #figure() don't get # prefix
    # BUT: Do NOT wrap in #figure() if inside a table!

    # Strategy: Process content tracking table context, only wrap in #figure() when NOT in table
    def wrap_images_with_captions(text):
        """Wrap image+caption pairs in #figure(), but NOT if inside tables"""
        lines = text.split('\n')
        result = []
        in_table = False
        bracket_depth = 0
        i = 0

        while i < len(lines):
            line = lines[i]

            # Track table context
            if 'table(' in line or 'table.header(' in line or 'table.hline(' in line:
                in_table = True
                bracket_depth = line.count('(') - line.count(')')

            if in_table:
                bracket_depth += line.count('(') - line.count(')')
                if bracket_depth <= 0:
                    in_table = False

            # Check for image followed by caption pattern
            # Pattern: image("...", width: ...) on current line, caption on next line(s)
            image_match = re.match(r'\s*(#?image\("[^"]+",\s*width:\s*\d+%\))\s*$', line)

            if image_match and i + 1 < len(lines):
                next_line = lines[i + 1] if i + 1 < len(lines) else ""
                next_next = lines[i + 2] if i + 2 < len(lines) else ""

                # Check if next line is empty and line after has caption
                caption_match = None
                skip_lines = 0

                if next_line.strip() == '' and next_next.strip():
                    caption_match = re.match(r'\s*(Figure|Photo|Image|Illustration|Schéma|Graphique)\s+\d+\s*[:\-–—]?\s*(.+)', next_next, re.IGNORECASE)
                    skip_lines = 2
                elif next_line.strip().startswith(':'):
                    caption_match = re.match(r'\s*:\s*(.+)', next_line)
                    skip_lines = 1

                if caption_match:
                    image_call = image_match.group(1).lstrip('#')
                    caption_text = caption_match.group(0).strip().lstrip(':').strip()

                    if not in_table:
                        # Create #figure() wrapper
                        result.append(f'#figure(')
                        result.append(f'  {image_call},')
                        result.append(f'  caption: [{caption_text}]')
                        result.append(')')
                        i += skip_lines + 1
                        continue
                    else:
                        # In table - keep as-is without #figure
                        result.append(line)
                        i += 1
                        continue

            result.append(line)
            i += 1

        return '\n'.join(result)

    content = wrap_images_with_captions(content)

    # NOW add # prefix to remaining standalone images (not inside #figure())
    # This fixes images in table cells, table headers, and other standalone contexts
    # We need to be careful NOT to add # to images inside #figure()

    # Strategy: Add # only to image() calls that are:
    # 1. Not already prefixed with #
    # 2. Not inside #figure() constructs

    # Split content by #figure() blocks and only process non-figure parts
    # This ensures images inside #figure() keep their non-# prefix

    def add_hash_to_standalone_images(text):
        """Add # prefix to image() calls, but NOT if they're inside #figure()"""
        # Don't add # if preceded by #, or if we're in a figure context
        # Check if image(" appears after "  " (indentation inside figure)
        lines = text.split('\n')
        result = []
        in_figure = False
        figure_depth = 0

        for line in lines:
            # Track if we're inside a #figure() block
            if '#figure(' in line:
                in_figure = True
                figure_depth = line.count('(') - line.count(')')
            elif in_figure:
                figure_depth += line.count('(') - line.count(')')
                if figure_depth <= 0:
                    in_figure = False

            # Only add # to image() if we're NOT inside a figure
            if not in_figure and 'image("' in line and '#image("' not in line:
                # Add # to image(" if not already present
                line = re.sub(r'(?<![#a-zA-Z])image\("', r'#image("', line)

            result.append(line)

        return '\n'.join(result)

    content = add_hash_to_standalone_images(content)

    # Convert Greek letters and special math symbols to Typst equivalents
    # Map Unicode Greek letters to Typst math mode
    greek_map = {
        'α': '$alpha$', 'β': '$beta$', 'γ': '$gamma$', 'δ': '$delta$',
        'ε': '$epsilon$', 'ζ': '$zeta$', 'η': '$eta$', 'θ': '$theta$',
        'ι': '$iota$', 'κ': '$kappa$', 'λ': '$lambda$', 'μ': '$mu$',
        'ν': '$nu$', 'ξ': '$xi$', 'ο': '$omicron$', 'π': '$pi$',
        'ρ': '$rho$', 'σ': '$sigma$', 'τ': '$tau$', 'υ': '$upsilon$',
        'φ': '$phi$', 'ϕ': '$phi$', 'χ': '$chi$', 'ψ': '$psi$', 'ω': '$omega$',
        'Α': '$Alpha$', 'Β': '$Beta$', 'Γ': '$Gamma$', 'Δ': '$Delta$',
        'Ε': '$Epsilon$', 'Ζ': '$Zeta$', 'Η': '$Eta$', 'Θ': '$Theta$',
        'Ι': '$Iota$', 'Κ': '$Kappa$', 'Λ': '$Lambda$', 'Μ': '$Mu$',
        'Ν': '$Nu$', 'Ξ': '$Xi$', 'Ο': '$Omicron$', 'Π': '$Pi$',
        'Ρ': '$Rho$', 'Σ': '$Sigma$', 'Τ': '$Tau$', 'Υ': '$Upsilon$',
        'Φ': '$Phi$', 'Χ': '$Chi$', 'Ψ': '$Psi$', 'Ω': '$Omega$',
        '√': '$sqrt$', '∞': '$infinity$', '≈': '$approx$', '≠': '$eq.not$',
        '≤': '$lt.eq$', '≥': '$gt.eq$', '±': '$plus.minus$', '×': '$times$',
        '÷': '$div$', '∑': '$sum$', '∏': '$product$', '∫': '$integral$',
        'ℓ': '$ell$', '∂': '$diff$', '∇': '$nabla$', '∆': '$Delta$'
    }

    for greek_char, typst_equiv in greek_map.items():
        content = content.replace(greek_char, typst_equiv)

    # Remove redundant table cell alignments
    # When table has global align: (center,center,...), individual table.cell(align: center) is redundant
    # Keep table.cell() with colspan, rowspan, or other special properties
    content = re.sub(r'table\.cell\(align: center\)\[', r'[', content)

    # Clean up multiple blank lines
    content = re.sub(r'\n\n\n+', '\n\n', content)

    # Add section comments for major headings FIRST
    # This helps with manual editing AND is needed for TOC removal to work
    content = re.sub(
        r'\n(= [^\n]+)\n',
        r'\n// Section: \1\n\1\n',
        content
    )

    # Remove Pandoc-generated table of contents (TOC)
    # Pandoc creates TOC as:
    # 1. A heading like "Sommaire" or "= #strong[SOMMAIRE]"
    # 2. Followed by many lines with #link() references
    # We want to replace this with Typst's #outline() command

    # Pattern 1: Remove simple "Sommaire" or "SOMMAIRE" heading followed by #link() or numbered entries
    # Example patterns:
    # SOMMAIRE
    #
    # 1 Objet de la note #link(<objet-de-la-note>)[4]
    # 2 Documents de référence #link(<documents-de-référence>)[4]
    # OR:
    # Sommaire
    #
    # #link(<section1>)[1 Section Title 2]
    # #link(<section2>)[2 Another Section 4]
    content = re.sub(
        r'^(SOMMAIRE|Sommaire|#strong\[SOMMAIRE\])\n\n((?:\d+\s+[^\n]+\s+#link\(<[^>]+>\)\[\d+\]\n\n?)|(?:#link\(<[^>]+>\)\[.*?\]\n\n?))*',
        '',
        content,
        flags=re.MULTILINE
    )

    # Pattern 2: Remove the entire SOMMAIRE/TOC section with heading
    # The section includes:
    # - Comment line: // Section: = #strong[SOMMAIRE]
    # - Heading: = #strong[SOMMAIRE]
    # - Anchor: <sommaire>
    # - Many lines with #link() entries (with blank lines between)
    # - Stops at the next "// Section:" comment
    content = re.sub(
        r'// Section: = #strong\[SOMMAIRE\]\n'
        r'= #strong\[SOMMAIRE\]\n'
        r'<sommaire>\n'
        r'.*?'  # Match everything (non-greedy)
        r'(?=// Section: = [A-Za-z])',  # Stop before next section with actual letters
        '',
        content,
        flags=re.DOTALL
    )

    # Pattern 3: Remove "Table des matières" heading and all #link() TOC entries
    # This handles Pandoc's format:
    # Table des matières
    #
    # #link(<anchor>)[1 Title #link(<anchor>)[5];]
    #
    # #link(<anchor>)[1.1 Subtitle #link(<anchor>)[5];]
    # ...
    # Stops when it hits a real heading like "= Généralités"
    # Use DOTALL to match across newlines, and stop before the first real heading
    before_toc_removal = len(content)
    content = re.sub(
        r'Table des matières\s*\n\s*(?:#link\(<[^>]+>\)\[.*?\];\]\s*\n\s*)+',
        '',
        content,
        flags=re.MULTILINE
    )
    after_toc_removal = len(content)
    if before_toc_removal != after_toc_removal:
        print(f"      Removed Pandoc TOC ({before_toc_removal - after_toc_removal} chars)")

    # Pattern 3b: Also remove standalone #link() lines (any remaining TOC entries)
    # These have the format: #link(<anchor>)[text #link(<anchor>)[number];]
    content = re.sub(
        r'^\s*#link\(<[^>]+>\)\[.*?#link\(<[^>]+>\)\[[^\]]+\];\]\s*$',
        '',
        content,
        flags=re.MULTILINE
    )

    # Pattern 4: Remove #block[ #set enum ... ] + #link() patterns (nested TOC entries)
    content = re.sub(
        r'#block\[\n#set enum\([^)]+\)\n(?:\+ #link\(<[^>]+>\)\[.*?\];\n)+\]\n',
        '',
        content,
        flags=re.MULTILINE
    )

    # Add Typst outline command at the beginning (after header comment and before first heading)
    # Insert after the header comment and before the first = heading
    typst_outline = '''#outline(
  depth: 2,
  title: "Sommaire"
)

#pagebreak()

'''

    # Find the position after header comments and before first content
    # Look for the first heading (= ) that's not in a comment
    first_heading_match = re.search(r'\n(= [^\n]+)', content)

    if first_heading_match:
        insert_pos = first_heading_match.start()
        # Check if there's already an #outline command
        if '#outline' not in content[:insert_pos]:
            # Add weak pagebreak before outline for better formatting
            outline_with_pagebreak = '\n#pagebreak(weak: true)\n' + typst_outline
            content = content[:insert_pos] + outline_with_pagebreak + content[insert_pos:]

    # Add page breaks before ALL level 1 sections (= headings, not == or ===)
    # Use weak page break so it won't create empty pages
    # Simple approach: add before every "= " line
    lines = content.split('\n')
    processed_lines = []

    for i, line in enumerate(lines):
        # Add page break before every level 1 heading (= but not ==)
        if line.startswith('= ') and not line.startswith('== '):
            processed_lines.append('#pagebreak(weak: true)')

        processed_lines.append(line)

    content = '\n'.join(processed_lines)

    # Final step: Remove additional SOMMAIRE patterns with numbered TOC entries
    # Pattern: #strong[SOMMAIRE] followed by lines like "1 Title #link(<...>)[page]"
    content = re.sub(
        r'#strong\[SOMMAIRE\]\s*\n\n((?:\d+(?:\.\d+)*\s+[^\n]+\s+#link\(<[^>]+>\)\[\d+\]\s*\n\n?)+)',
        '',
        content,
        flags=re.DOTALL
    )
    # Remove standalone #strong[SOMMAIRE] if still present
    content = re.sub(r'#strong\[SOMMAIRE\]\n\n', '', content)
    # Remove remaining numbered TOC entries
    content = re.sub(r'^\d+(?:\.\d+)*\s+[^\n]+\s+#link\(<[^>]+>\)\[\d+\]\s*\n', '', content, flags=re.MULTILINE)

    return content

def fix_math_subscripts_superscripts(content):
    """
    Convert #sub[] and #super[] to Typst _ and ^ syntax
    This fixes math formulas from Word that use markup instead of math notation
    """

    def convert_sub(match):
        """Convert #sub[content] to _(content) with proper quoting"""
        content_text = match.group(1).strip()
        # Remove trailing semicolons
        content_text = content_text.rstrip(';')
        # If it contains spaces, commas, or special chars, quote it
        if ',' in content_text or ' ' in content_text or len(content_text) > 3:
            return f'_("{content_text}")'
        else:
            return f'_{content_text}'

    def convert_super(match):
        """Convert #super[content] to ^(content) with proper quoting"""
        content_text = match.group(1).strip()
        # Remove trailing semicolons
        content_text = content_text.rstrip(';')
        # If it contains spaces, commas, or special chars, quote it
        if ',' in content_text or ' ' in content_text or len(content_text) > 3:
            return f'^("{content_text}")'
        else:
            return f'^{content_text}'

    # Convert all #sub[...] patterns
    content = re.sub(r'#sub\[([^\]]+)\]', convert_sub, content)

    # Convert all #super[...] patterns
    content = re.sub(r'#super\[([^\]]+)\]', convert_super, content)

    return content

def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(
        description='Convert DOCX to Typst format for manual editing',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Convert with default output name
  python convert_docx_to_typst.py document.docx

  # Convert with custom output name
  python convert_docx_to_typst.py document.docx output.typ

  # Interactive mode (prompts for file)
  python convert_docx_to_typst.py
        """
    )

    parser.add_argument(
        'docx_file',
        nargs='?',
        help='Input DOCX file (if not provided, will prompt interactively)'
    )

    parser.add_argument(
        'typst_file',
        nargs='?',
        help='Output .typ file (default: same name as input with .typ extension)'
    )

    parser.add_argument(
        '--no-template',
        action='store_true',
        help='Built-in formatting is always used (kept for compatibility)'
    )

    args = parser.parse_args()

    # Interactive mode if no file provided
    docx_file = args.docx_file
    if not docx_file:
        print("=== DOCX to Typst Converter ===\n")
        print("No input file specified. Please provide a DOCX file path.")
        print("You can drag and drop the file into this window, or type the path.\n")

        while True:
            docx_file = input("DOCX file path: ").strip().strip('"').strip("'")
            if docx_file and Path(docx_file).exists():
                break
            elif docx_file:
                print(f"Error: File not found: {docx_file}")
                print("Please try again.\n")
            else:
                print("Error: No file path provided.")
                return 1

    # Verify file exists
    docx_path = Path(docx_file)
    if not docx_path.exists():
        print(f"Error: File not found: {docx_file}")
        return 1

    success = convert_docx_to_typst(
        docx_file,
        args.typst_file,
        apply_template=not args.no_template
    )

    return 0 if success else 1

if __name__ == '__main__':
    sys.exit(main())
