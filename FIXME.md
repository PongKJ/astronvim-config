#  修复代码区保存时自动折叠的问题
> Processing:导致问题的原因为`foldlevel`被错误的设置为0,导致自动折叠,使用`:set
 foldlevel=99`以防止自动折叠,导致原因目前未知

# 修复打开图片文件闪退的问题
> Success:原因非neovim所致,由终端bug导致

# 修复工作区类型识别错误的问题
> Update:更新工作区类型识别逻辑

# 修复pastify插件无法正常工作的问题
> Fixed:将python版本由3.7升级为3.10

# 修复Format操作时,指定format格式文件(对于clang-format,.clang-format文件)无效
> Fixed:导致问题的原因为执行Format操作时存在多个可以完成Format操作的client,
 对于c/c++,对应为clangd和null-ls::clang-format,即使在null-ls配置clang-format
 的格式化配置文件后,由于格式化的代码被clangd格式化的结果覆盖导致看起来不起作
 用;对于cmake,neocmake与cmake-format同样存在此问题
 解决方案1:在AstroLsp中启用filter进行client的过滤,只接受null-ls的格式化操作
 解决方案2:在AstroLsp中关闭clangd和neocmake的代码格式化功能

# 使用mason+mason-null-ls+none-ls,没有自动完成cmake_format的setup
> 导致问题的原因为:cmake_format不是通过mason-null-ls自动安装的,手动安装的无法实现
 对其的自动配置和启动,或者是因为python虚拟环境的问题?
 解决方案:卸载手动安装的cmake_format包,通常是通过`pip install cmakelang`安装的,
 通过执行`pip uninstall cmakelang` 对其进行卸载

# 修复打开部分文件导致clangd LSP异常退出

# 修复c/cpp工程cmake添加新的依赖更新compile_commands.json后,clangd LSP功能异常的问题

# 修复c/c++项目弹出signature help时,光标移动到signature上的问题
> astronvim 与 noice.nvim插件的signature冲突导致,关闭astronvim的signature help,问题解决

# 使用Session reload, cwd()仍然为启动nvim的目录问题导致dotfile find错误
