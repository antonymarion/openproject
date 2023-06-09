mergeIds=$(git log --pretty=format:'%h' --merges)
mergeCount=$(echo "$mergeIds" | wc -l)
conflictCount=0
totalFileCount=0
for mergeId in $mergeIds; do
  log=$(git log $mergeId -n 1)
  if [[ $log == *"    Conflicts:"* ]]; then
    echo "$log"
    echo "Conflict: Yes"
    fileCount=$(echo "$log" | wc -w)
    fileCount=$((fileCount - 8))
    echo "Conflicts in $fileCount files"

    conflictCount=$((conflictCount + 1))
    totalFileCount=$((totalFileCount + fileCount))
  fi
done
percentage=$(bc -l <<< "$conflictCount * 100 / $mergeCount")
echo "$percentage % of all non-forward merges had conflicts ($conflictCount / $mergeCount)."
filesPerConflict=$(bc -l <<< "$totalFileCount / $conflictCount")
echo "On average, $filesPerConflict conflicting files per conflicting merge ($totalFileCount / $conflictCount)."
