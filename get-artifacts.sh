tok=$(cat ../token.gh)

jq '.artifacts[].id' gh1.json > liste_id

mkdir -p out/
rm -rf out/*

for a in $(cat liste_id)
do
    echo "requête $a"
    
    # Téléchargement du fichier
    curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $tok" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      --output out/$a.zip \
      https://api.github.com/repos/ZeFix-c-tout/graphes/actions/artifacts/$a/zip 2> /dev/null

    if [ $? -eq 0 ]; then
      echo "Téléchargement réussi pour $a, extraction..."
      mkdir -p out/$a
      unzip -o -d out/$a out/$a.zip 2>/dev/null
      
      if [ $? != 0 ]; then
        echo "Erreur, le fichier $a n'est pas une archive valide."
      fi
    else
      echo "Erreur lors du téléchargement de $a"
    fi
done

