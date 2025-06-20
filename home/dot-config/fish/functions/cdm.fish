function cdm --description 'Create a directory and change to it'
    if test (count $argv) -ne 1
        echo "Usage: cdm <directory_name>"
        return 1
    end
  mkdir -p $argv[1]; and cd $argv[1]
end
