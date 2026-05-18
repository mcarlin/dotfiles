local function open_diagram_external()
  local ft = vim.bo.filetype
  local integration_name = ft == "markdown" and "markdown" or ft == "norg" and "neorg" or nil
  if not integration_name then
    vim.notify("Diagram preview is only configured for markdown and norg", vim.log.levels.WARN)
    return
  end

  local integration = require("diagram.integrations." .. integration_name)
  local diagrams = integration.query_buffer_diagrams(vim.api.nvim_get_current_buf())
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local target = nil

  for _, diagram in ipairs(diagrams) do
    if row >= diagram.range.start_row and row <= diagram.range.end_row then
      target = diagram
      break
    end
  end

  if not target then
    vim.notify("No diagram found at cursor", vim.log.levels.INFO)
    return
  end

  local renderer = require("diagram.renderers")[target.renderer_id]
  if not renderer then
    vim.notify("Unsupported diagram renderer: " .. target.renderer_id, vim.log.levels.ERROR)
    return
  end

  local renderer_options = {
    mermaid = {
      theme = "default",
      background = nil,
      scale = 1,
    },
  }

  local result = renderer.render(target.source, renderer_options[target.renderer_id] or {})
  if not result then
    return
  end

  local open_result = function()
    if vim.fn.filereadable(result.file_path) == 1 then
      vim.ui.open(result.file_path)
    else
      vim.notify("Diagram file not found: " .. result.file_path, vim.log.levels.ERROR)
    end
  end

  if result.job_id then
    local timer = vim.uv.new_timer()
    if not timer then
      open_result()
      return
    end
    timer:start(
      0,
      100,
      vim.schedule_wrap(function()
        local status = vim.fn.jobwait({ result.job_id }, 0)
        if status[1] ~= -1 then
          if timer:is_active() then
            timer:stop()
          end
          if not timer:is_closing() then
            timer:close()
          end
          open_result()
        end
      end)
    )
  else
    open_result()
  end
end

return {
  {
    "3rd/image.nvim",
    build = false,
    ft = { "markdown", "norg" },
    opts = function()
      return {
        backend = vim.env.TERM_PROGRAM == "WezTerm" and "sixel" or "kitty",
        processor = "magick_cli",
        integrations = {
          markdown = { enabled = false },
          neorg = { enabled = false },
          html = { enabled = false },
          css = { enabled = false },
          rst = { enabled = false },
          typst = { enabled = false },
          asciidoc = { enabled = false },
        },
        max_height_window_percentage = 50,
        window_overlap_clear_ft_ignore = {
          "cmp_menu",
          "cmp_docs",
          "snacks_notif",
          "scrollview",
          "scrollview_sign",
        },
      }
    end,
  },
  {
    "3rd/diagram.nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown", "norg" },
    opts = function()
      return {
        events = {
          render_buffer = {},
          clear_buffer = { "BufLeave" },
        },
        integrations = {
          require("diagram.integrations.markdown"),
          require("diagram.integrations.neorg"),
        },
        renderer_options = {
          mermaid = {
            theme = "default",
            background = nil,
            scale = 1,
          },
        },
      }
    end,
    keys = {
      {
        "<leader>ud",
        open_diagram_external,
        ft = { "markdown", "norg" },
        desc = "Open Diagram",
      },
    },
  },
}
