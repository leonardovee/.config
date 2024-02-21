local nnoremap = require("leonardovee.keymap").nnoremap

nnoremap("<leader>te", "<cmd>:Telescope<CR>")
nnoremap("<leader>ff", "<cmd>:Telescope find_files<CR>")
nnoremap("<leader>fg", "<cmd>:Telescope live_grep<CR>")
nnoremap("<leader>fb", "<cmd>:Telescope buffers<CR>")
nnoremap("<leader>fh", "<cmd>:Telescope help_tags<CR>")

nnoremap("<leader>fe", "<cmd>:Explore<CR>")

nnoremap("<leader>db", "<cmd>:DapContinue<CR>")
nnoremap("<leader>dq", "<cmd>:DapTerminate<CR>")
nnoremap("<leader>do", "<cmd>:DapStepOut<CR>")
nnoremap("<leader>di", "<cmd>:DapStepInto<CR>")
nnoremap("<leader>dt", "<cmd>:DapStepOut<CR>")
nnoremap("<leader>dr", "<cmd>:DapToggleRepl<CR>")
nnoremap("<leader>dp", "<cmd>:DapToggleBreakpoint<CR>")

