require("neo-tree").setup({
    close_if_last_window = false,
    popup_border_style   = "rounded",
    enable_git_status    = false,
    enable_diagnostics   = false,
    find_command         = "fd",
    bind_to_cwd          = true,

    default_component_configs = {
      indent = {
        indent_size        = 2,
        padding            = 0, -- extra padding on left hand side
        with_markers       = true,
        indent_marker      = "│",
        last_indent_marker = "└",
        highlight          = "NeoTreeIndentMarker",
      },

      icon = {
        folder_closed = "",
        folder_open   = "",
        folder_empty  = "ﰊ",
        default       = "*",
      },

      name = {
        trailing_slash        = false,
        use_git_status_colors = false,
      },

    },

    filesystem = {
      filters = {
        show_hidden       = true,
        respect_gitignore = false,
      },

      follow_current_file    = true,
      use_libuv_file_watcher = true,
      hijack_netrw_behavior  = "open_default",

      window = {
        position = "left",
        width    = 30,
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["C"] = "close_node",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["I"] = "toggle_gitignore",
          ["R"] = "refresh",
          ["/"] = "fuzzy_finder",
          --["/"] = "filter_as_you_type", -- this was the default until v1.28
          --["/"] = "none" -- Assigning a key to "none" will remove the default mapping
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
        }
      }
    },

    buffers = {
      show_unloaded = true,
      window = {
        position = "left",
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"]    = "open_split",
          ["s"]    = "open_vsplit",

          ["<bs>"] = "navigate_up",
          ["."]    = "set_root",

          ["R"] = "refresh",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",

          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",

          ["bd"] = "buffer_delete",
        }
      },
    },
})
