extract() {
  for file in "$@"
  do
      if [ -f $file ] ; then
          ex $file
      else
          echo "'$file' is not a valid file"
      fi
  done
}

mkextract() {
  for file in "$@"
  do
      if [ -f $file ] ; then
          local filename=${file%\.*}
          mkdir -p $filename
          cp $file $filename
          cd $filename
          ex $file
          rm -f $file
          cd -
      else
          echo "'$1' is not a valid file"
      fi
  done
}

ex() {
  case $1 in
      *.tar.bz2)  tar xjf $1      ;;
      *.tar.gz)   tar xzf $1      ;;
      *.bz2)      bunzip2 $1      ;;
      *.gz)       gunzip $1       ;;
      *.tar)      tar xf $1       ;;
      *.tbz2)     tar xjf $1      ;;
      *.tgz)      tar xzf $1      ;;
      *.zip)      unzip $1        ;;
      *.7z)       7z x $1         ;; # requires p7zip
      *.rar)      7z x $1         ;; # requires p7zip
      *.iso)      7z x $1         ;; # requires p7zip
      *.Z)        uncompress $1   ;;
      *)          echo "'$1' cannot be extracted" ;;
  esac
}

pdfextract() {
  # PDF extract uses 3 arguments:
  #   $1 is the first page of the range to extract
  #   $2 is the last page of the range to extract
  #   $3 is the input file
  #   output file will be named "inputfile_pXX-pYY.pdf"
  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
     -dFirstPage=${1} \
     -dLastPage=${2} \
     -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
     ${3}
}
