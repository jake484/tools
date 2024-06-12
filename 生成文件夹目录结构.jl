####################### README ########################
# 1. 该脚本用于生成文件夹目录                           #
# 2. 使用方法: julia genDirStruct.jl 文件夹路径        #
# 3. 生成的文件夹目录保存在dirStruct.txt文件中          #
####################### README #######################


# 读取文件夹内容并生成文件夹目录
const PREFIX_DIR = "├── " # 文件夹前缀
const PREFIX_T = "    " # 文件夹前缀
const PREFIX_END = "└── " # 文件夹前缀

function genDir(path, level=0, contents=String[])
    # 读取文件夹内容
    files = readdir(path)
    # 生成文件夹目录
    for (index, file) in enumerate(files)
        file == ".git" && continue
        if isdir(joinpath(path, file))
            if lastindex(files) == index
                push!(contents, repeat(PREFIX_T, level) * PREFIX_END * file)
            else
                push!(contents, repeat(PREFIX_T, level) * PREFIX_DIR * file)
            end
            genDir(joinpath(path, file), level + 1, contents)
        else
            if lastindex(files) == index
                push!(contents, repeat(PREFIX_T, level) * PREFIX_END * file)
            else
                push!(contents, repeat(PREFIX_T, level) * PREFIX_DIR * file)
            end
        end
    end
    return contents
end

@info "正在生成" * ARGS[1] * "文件夹目录"

write("dirStruct.txt", join(genDir(ARGS[1]), "\n"));

@info "文件夹目录已生成在dirStruct.txt文件中!"