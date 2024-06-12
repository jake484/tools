####################### README ###########################
# 1. 该脚本用于读取代码并删除所有空行                       #
# 2. 使用方法(终端运行): julia readCode.jl 文件夹绝对路径   #
# 3. 生成内容保存在file1.txt，file2.txt文件中（前后各30页） #
####################### README ###########################

function readDirContent(dirname="src/", contents=String[], stop=1500)
    length(contents) >= stop && return contents
    files = readdir(dirname, join=true)
    for file in files
        if isdir(file)
            readDirContent(file, contents, stop)
        else
            if endswith(file, ".jl") || endswith(file, ".vue") || endswith(file, ".ts")
                content = readlines(file)
                append!(contents, filter(x -> !isempty(x) && length(x) <= 48, content))
            end
        end
    end
    return contents
end

"""
读取多个文件夹内容

dirs: 文件夹路径，每个文件夹路径为一个字符串

"""
function readMultDir(dirs)
    file1, file2 = readDirContent(dirs[1]), readDirContent(dirs[2])
    map(enumerate((file1, file2))) do (i, file)
        if length(file) < 1500
            @error "file$i.jl is too short!"
        else
            open("file$i.jl", "w") do io
                write(io, join(file[1:1500], "\n"))
            end
            @info "write file$i.jl!"
        end
    end
    return nothing
end

function readDir(path)
    file = readDirContent((joinpath(path)), String[], 3000)
    if length(file) < 3000
        @error "too short! less than 3000 lines!"
    else
        open("file1.txt", "w") do io
            write(io, join(file[1:1500], "\n"))
        end
        @info "write file1.txt!"
        open("file2.txt", "w") do io
            write(io, join(file[1501:end], "\n"))
        end
        @info "write file2.txt!"
    end
    return nothing
end

readDir(ARGS[1])

# 查看文件后缀

