function __aiva_commit
  set -l branch (git rev-parse --abbrev-ref HEAD)
  set -l tag (string match -r 'AIVA-[0-9]+' $branch | head -n1)
  echo "git commit -m \"$tag %\""
end
