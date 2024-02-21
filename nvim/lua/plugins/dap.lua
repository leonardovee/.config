return {
    "mfussenegger/nvim-dap",
    {
        "leoluz/nvim-dap-go",
        config = function()
            require("dap-go").setup()
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"]=function()
              dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"]=function()
              dapui.close()
            end

            dap.listeners.before.event_exited["dapui_config"]=function()
              dapui.close()
            end
        end,
    }
}
