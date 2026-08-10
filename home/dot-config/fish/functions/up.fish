function up --description 'Change directory up a specified number of levels'
    if test (count $argv) -gt 1
        echo "Usage: up [positive number]"
        return 1
    else if test (count $argv) -eq 0
        cd ..
    else
        set -l levels $argv[1]
        if string match -qr '^[1-9]\d*$' $levels
            set -l path (string repeat -n $levels '../')
            cd -- $path
        else
            echo "Usage: up [positive number]"
            return 1
        end
    end
end
