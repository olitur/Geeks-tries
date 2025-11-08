# Aim

Produce a nice pdf via Typst for a cooking recipe plus exercizes for childrens.
This file will be "generic" to metadata infos provided in a separate file and adopt a style file shared with all future recipes.
Each pair of infos and recipe share the same name because there will be several recipes in the same folder.


# Steps

## Part I

1. template and structure of root folder for this "exercise" :

	- produce a template "style_recettes.typ", style copied from `C:\Users\oturl\Documents\geeks\Typst-tries\capture-news-articles_2_pdf-whith-style\003_peter-Thiel-copy\style.typ` (page: a4, margins: auto, lang: fr, font(main and fallback), headers, footers, h1/h2/h3 titles, etc.) all "generic" style which can be exported from this particular case style file
	- copy fonts used in the style file in a dedicated dir for use them, under `.assets/fonts`
	- add dir `.assets/images` also, where user will put particular images like logoimage(s) for illustration purpose


2. Metadata "informations" (`.txt` or `.typ` or `.yml` extension, which fits the best but stay simple for editing foo a future "noob" user, `.yml` might be tricky to edit because of indentations) file to be retrieved by future "`recette_[name of recipe].typ`" file, all texts in french. 
Better name it : "`informations_[name of recipe].txt`" because it will be several differents recipes.
if infos omited, no problem for further use

	- Name/title of the recipe 
		- for exemple, the user will enter "Madeleines au beurre"
		- Notice the spaces that the varaible must cope with for proper compilation
	
	- Ingredients 
		- ingredient#1
			- ingredient_name : [ ]
			- ingredient_quantity : [ ]
			- ingredient_price (in euros)
				- cost for bulk buy (like "flour" "1 kg")
					- bulk quantity
					- bulk price
				- cost for ingredient in recipe (like for Flour : 250 gr) do the maths
					- quantity used
					- resulting cost (bulk price/quantity used)
		- ingredient#2
			- .. [ ]
			- .. [ ]
		-ingredient#n (n=10 !)
			- 
			-
	
	- Preparation
		- step#1 : [ ]
		- step#2 : [ ]
		..
		- step#n

	- Cooking
		- time
		- temp (metric units : degres and "thermostat" oven digit number equivalent, ranging from 1 to 8 I guess)
		- in which "moule/recipient"
		- prior pecautions (like "buttering" the "moule" ?)
		- verifications steps during the cooking ()
		- verification step at the end (like put a bid needle in the cake to see if surface of the needle is dry when pulled outside)

	- Serving
		- time after cooking
		- how much items (like for small cake "madeleines" none if only one big cake)
		- how much persons

	- price of differents ingredients and other costs
		- so add a variable for each ingredient
		- energy price (electric oven)

	- other informations I've omited

3. "recette_[name of recipe].typ"

	- name of file : "recette_[name of recipe].typ"
	- style from "style_recettes.typ" to be imported
	- metadata infos from "informations_[name of recipe].txt"

4. "cout-revient_[name of recipe].typ" : 
	
	- quick recap of recipe
	- computation of estimated individual costs plus what's left form bulk buys

4. README.md file indicationg to "noob" user what to do :
	
	- collect infos wherever for a specific recipe (ingredients, preparation, cooking, serving, prices, images)
	- generate the file locally : what software chain to install
	- generate on the web with Typst web interface, having the complete structure folder, file (describe it)


5. Optimisation

	- create a dedicated folder for each recipe
	- all `recipe+name.typ` file will call style file from a root folder `.assets/style/style.typ` file 
	- the folder `.assets/style/` will contain a logo file to be put on th lower left corner, use `"C:\Users\oturl\Documents\geeks\Geeks-tries\retaining_wall_report\images\canopee_logo.jpg"`
	- images folder will be duplicated in each recipe folder for better clarity


> [!TIP]
> Ressources given are from my hard drive, I'll put them in the repository for better access online
> I'll populate the folder structure for a clean start

## Part II

Create a real exemple based on the infos I'll write in a file `informations_madeleines.txt` for the recipe of "Madeleines au beurre", including an image of madeleines put in the images folder.