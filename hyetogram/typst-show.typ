#show: article.with(
$if(title)$
  title: "$title$",
$endif$
$if(author)$
  author: "$author$",
$endif$
$if(params.species)$
  species: "$params.species$",
$endif$
$if(filepath)$
  filepath: "$filepath$",
$endif$
)