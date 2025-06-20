function up --description 'Change directory up a specified number of levels'
    if test (count $argv) -eq 0
        cd ..
    else
        set -l levels $argv[1]
        if string match -qr '^\d+$' $levels
            set -l path (string repeat -n $levels '../')
            cd $path
        else
            echo "Usage: up [number]"
            return 1
        end
    end
end
