tobefilterfile=../../file/
for dir in $(ls ${tobefilterfile})
do 
    for logdir in $(ls ${tobefilterfile}${dir})
    do
        lua filter.lua ${tobefilterfile}${dir}/${logdir}/${logdir}  # 文件与文件夹同名
    done
done
