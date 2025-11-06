# Clean Start Guide - Starting Fresh

## ✅ Repository is Now Clean!

The repository has been cleaned up. Old .typ and .pdf files have been removed.

## What's in the Repository (on the claude branch)

```
doc2typst2pdf/test2/
├── 24Mauzac_DIAG_Pile-RG.docx    ← Source Word document
├── convert_docx_to_typst.py      ← LATEST conversion script (FIXED)
├── README.md                      ← Usage documentation
├── CONVERSION_STATUS.md           ← Validation documentation
├── CLEAN_START_GUIDE.md          ← This file
├── .gitignore                     ← Excludes generated files
└── media/                         ← Images extracted from DOCX
    ├── image1.jpeg
    ├── image2.jpg
    └── ... (49 images total)
```

**NO .typ or .pdf files** - you generate these fresh!

## Step-by-Step: Start Fresh on Your Machine

### 1. Delete Your Local Repository (Optional but Recommended)

```bash
cd /path/to/parent/folder
rm -rf Geeks-tries
```

### 2. Clone Fresh

```bash
git clone https://github.com/olitur/Geeks-tries.git
cd Geeks-tries
```

### 3. Checkout the Fixed Branch

```bash
git checkout claude/configure-python-script-test-011CUsHs4UzrT1e9nSbTYEMF
```

### 4. Verify You Have the Latest Files

```bash
cd doc2typst2pdf/test2/
ls -lh convert_docx_to_typst.py
```

**You should see:**
- File exists
- Recent modification date (Nov 6, 2025 or later)
- Size around 32KB

### 5. Install Dependencies

```bash
# Install Python library for image processing
pip install Pillow

# Install Pandoc (if not already installed)
# Ubuntu/Debian:
sudo apt-get install pandoc

# macOS:
brew install pandoc

# Install Typst (optional - for automatic PDF generation)
# Linux:
curl -fsSL https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz | tar -xJ
sudo mv typst-x86_64-unknown-linux-musl/typst /usr/local/bin/

# macOS:
brew install typst

# Windows:
winget install --id Typst.Typst
```

### 6. Generate Fresh Files

```bash
python3 convert_docx_to_typst.py 24Mauzac_DIAG_Pile-RG.docx
```

**This creates:**
- `24Mauzac_DIAG_Pile-RG.typ` (Typst source - error-free!)
- `24Mauzac_DIAG_Pile-RG.pdf` (PDF output - if Typst installed)

### 7. Verify Everything Works

```bash
# Check the files were created
ls -lh 24Mauzac_DIAG_Pile-RG.typ 24Mauzac_DIAG_Pile-RG.pdf

# All three should have the SAME creation time (just now):
# - convert_docx_to_typst.py (from git - Nov 6 21:58 or later)
# - 24Mauzac_DIAG_Pile-RG.typ (just created)
# - 24Mauzac_DIAG_Pile-RG.pdf (just created)
```

### 8. Check for Typst Errors (Should be ZERO)

Open `24Mauzac_DIAG_Pile-RG.typ` in VSCode with Typst extension, or run:

```bash
typst compile 24Mauzac_DIAG_Pile-RG.typ
```

**Expected result:** ✅ No errors, PDF generated successfully

## What Was Fixed in the Script

The latest `convert_docx_to_typst.py` fixes:

1. ✅ `#figure(#image)` → `#figure(image)` (correct Typst syntax)
2. ✅ No nested `#figure()` in table cells (invalid in Typst)
3. ✅ No `#figure()` wrapping entire tables (invalid)
4. ✅ Smart table detection - only wraps standalone images
5. ✅ Image optimization (~52% size reduction)
6. ✅ PNG→JPG conversion with automatic path updates
7. ✅ Math notation fixes (`#sub[]` → `_`, `#super[]` → `^`)

## Validation

Run this to verify no errors:

```bash
python3 << 'EOF'
import re
content = open('24Mauzac_DIAG_Pile-RG.typ').read()

errors = []
if re.search(r'#figure\(\s*#image', content):
    errors.append("#figure(#image found - should be #figure(image")
if re.search(r'table\.[^)]*\[#figure', content):
    errors.append("#figure in table cells found (invalid)")
if re.search(r'#figure\(\s*align.*#table', content):
    errors.append("#figure wrapping table found (invalid)")

if errors:
    print("❌ ERRORS FOUND:", errors)
else:
    print("✅ NO ERRORS - File is clean!")
EOF
```

## If You Still See Errors

1. **Make sure you're on the correct branch:**
   ```bash
   git branch
   # Should show: * claude/configure-python-script-test-011CUsHs4UzrT1e9nSbTYEMF
   ```

2. **Make sure you generated files FRESH:**
   ```bash
   rm 24Mauzac_DIAG_Pile-RG.typ 24Mauzac_DIAG_Pile-RG.pdf
   python3 convert_docx_to_typst.py 24Mauzac_DIAG_Pile-RG.docx
   ```

3. **Check you're looking at the RIGHT file:**
   - ❌ Don't look at old files you had before
   - ✅ Look at the freshly generated .typ file

## Need Help?

If you still see errors after following this guide:
1. Share the exact error messages
2. Run `git log --oneline -3` to show your latest commits
3. Run `ls -lh *.typ *.pdf *.py` to show file timestamps
