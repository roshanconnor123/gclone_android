echo "Welcome to gclone"
echo "checking Account/ folder"
if test -f "rc.conf"; then
	rm rc.conf
	echo -en "[GC]\ntype = drive\nscope = drive\nservice_account_file = accounts/1.json\nservice_account_file_path = accounts/" >> rc.conf
else	
    echo -en "[GC]\ntype = drive\nscope = drive\nservice_account_file = accounts/1.json\nservice_account_file_path = accounts/" >> rc.conf
fi    
echo -en "A.Copy\nB.Move\nC.Sync\nD.Dedupes\nE.RemoveDirs\nF.Size\nG.Dir listing\nNOTE:Read Rclone Documentations for more info on these operations\n"
read -p "Operation(Chose either A/B/C/D/E/F/G):" MD
if [ $MD == "A" ]; then
  echo -en "Copy Selected\nIt will COPY content from SRC to DST\n"
  echo -en "Provide SRC Folder ID\n"
  read SRC
  echo -en "Provide DST Folder ID\n"
  read DST
  gclone copy GC:{$SRC} GC:{$DST} --config=rc.conf --transfers 50 -vP --stats-one-line --stats=15s --ignore-existing --drive-server-side-across-configs --drive-chunk-size 128M --drive-acknowledge-abuse --drive-keep-revision-forever
elif [ $MD == "B" ]; then
  echo -en "Move Selected\nIt will MOVE content from SRC to DST\n"
  echo -en "Provide SRC Folder ID\n"
  read SRC
  echo -en "Provide DST Folder ID\n"
  read DST
  gclone move GC:{$SRC} GC:{$DST} --config=rc.conf --transfers 50 -vP --stats-one-line --stats=15s --ignore-existing --drive-server-side-across-configs --drive-chunk-size 128M --drive-acknowledge-abuse --drive-keep-revision-forever
elif [ $MD == "C" ]; then
  echo -en "Sync Selected\nIt will Sync content of SRC to DST (it will delete any extra files that are there only in DST use it with caution)\n"
  echo -en "Provide SRC Folder ID\n"
  read SRC
  echo -en "Provide DST Folder ID\n"
  read DST
  gclone sync GC:{$SRC} GC:{$DST} --config=rc.conf --transfers 50 -vP --stats-one-line --stats=15s --ignore-existing --drive-server-side-across-configs --drive-chunk-size 128M --drive-acknowledge-abuse --drive-keep-revision-forever
elif [ $MD == "D" ]; then
  echo -en "Dedupe selected\nIt will delete any duplicate files present in given Folder ID [it compares md5 and naming]\n"
  echo -en "Provide Folder ID\n"
  read SRC
  echo -en "select delete mode\nA.interactive\nB.newest\nC.oldest\nD.largest\nE.smallest\n"
  read -p "Delete Mode(Chose either A/B/C/D/E):" DP
  if [ $DP == "A" ]; then
  echo -en "Interactive Mode selected\n"
  gclone dedupe --dedupe-mode interactive GC:{$SRC} --config=rc.conf --verbose=2
  elif [ $DP == "B" ]; then
  echo -en "Newest Mode selected\n"
  gclone dedupe --dedupe-mode newest GC:{$SRC} --config=rc.conf --verbose=2
  elif [ $DP == "C" ]; then
  echo -en "Oldest Mode selected\n"
  gclone dedupe --dedupe-mode oldest GC:{$SRC} --config=rc.conf --verbose=2
  elif [ $DP == "D" ]; then
  echo -en "Largest Mode selected\n"
  gclone dedupe --dedupe-mode largest GC:{$SRC} --config=rc.conf --verbose=2
  elif [ $DP == "E" ]; then
  echo -en "smallest Mode selected\n"
  gclone dedupe --dedupe-mode smallest GC:{$SRC} --config=rc.conf --verbose=2
  fi
elif [ $MD == "E" ]; then
  echo -en "RemoveDirs Selected\nRemoves Empty Directory From the given Folder ID\n"
  echo -en "Provide Folder ID\n"
  read SRC
  gclone rmdirs GC:{$SRC} --drive-use-trash=true --verbose=2 --fast-list --config=rc.conf
elif [ $MD == "F" ]; then
  echo -en "Size selected\nIt will give the Size of the folder ID\n"
  echo -en "Provide Folder ID\n"
  read SRC
  gclone size GC:{$SRC} --config=rc.conf
elif [ $MD == "G" ]; then
  echo -en "Directory Listing\nIt will list the content of the give folder ID into text named file.txt\n"
  echo -en "Provide Folder ID\n"
  read SRC
  if test -f "file.txt"; then
    echo "file.txt Exist so Removing it."
	rm file.txt
  fi
  gclone ls GC:{$SRC} >> file.txt --config=rc.conf
else echo "Please Read and provide the responce"
fi
