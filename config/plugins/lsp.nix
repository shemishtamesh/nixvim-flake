{ pkgs, ... }:
let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  diagnostic.settings = {
    signs = false;
    underline = true;
    virtual_text = true;
    severity_sort = true;
    update_in_insert = true;
  };
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        nixd = {
          enable = true;
          settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
        };
        pylsp = {
          enable = true;
          settings = {
            plugins = {
              ruff = {
                enabled = true;
                extendSelect = [
                  "E"
                  "W"
                  "Q"
                  "N"
                  "T10"
                  "ARG"
                  "FIX"
                  "ISC"
                  "D414"
                  "D417"
                  "D419"
                ];
                lineLength = 79;
                config = builtins.toString (
                  (pkgs.formats.toml { }).generate "ruff.toml" {
                    lint.flake8-implicit-str-concat.allow-multiline = false;
                  }
                );
              };
              pylsp_mypy = {
                enabled = true;
                overrides.__raw = # lua
                  ''
                    (function ()
                        local virtual_environment = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                        if virtual_environment then
                            return { "--python-executable", virtual_environment .. "/bin/python3", true }
                        end
                        return { true }
                    end)()
                  '';
              };
            };
          };
        };
        lua_ls = {
          enable = true;
          settings = {
            telemetry.enable = false;
            diagnostics.globals = [
              "vim"
              "love"
            ];
            workspace = {
              library = [
                "${pkgs.neovim}/share/nvim/runtime"
                "\${3rd}/love2d/library"
              ];
              checkThirdParty = false;
            };
            Lua = {
              hint = {
                enable = true;
                arrayIndex = "Enable";
                setType = true;
                paramName = "All";
                paramType = true;
              };
            };
          };
        };
        gopls = {
          enable = true;
          settings = {
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };
        tinymist = {
          enable = true;
          settings = {
            formatterMode = "typstyle";
            exportPdf = "onType";
            outputPath = "$root/target/$name";
          };
        };
        sqls.enable = true;
        yamlls.enable = true;
        openscad_lsp.enable = true;
      };
    };
    rustaceanvim.enable = true;
    typescript-tools.enable = true;
  };
  keymaps = [
    # defined outside of lsp for whichkey
    (keymap "n" "<leader>la" "<cmd>lua vim.lsp.buf.code_action()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>lf" "<cmd>lua vim.lsp.buf.format()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>ln" "<cmd>lua vim.lsp.buf.rename()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>lm" "<cmd>lua vim.lsp.buf.implementation()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>li" "<cmd>lua vim.lsp.buf.incoming_calls()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>lo" "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>lr" "<cmd>lua vim.lsp.buf.references()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>lh" "<cmd>lua vim.lsp.buf.signature_help()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>lt" "<cmd>lua vim.lsp.buf.type_definition()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>lc" "<cmd>lua vim.lsp.buf.typehierarchy()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>ls" "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>ll"
      "<cmd>lua vim.diagnostic.config({virtual_lines = not vim.diagnostic.config().virtual_lines, virtual_text = not vim.diagnostic.config().virtual_text})<CR>"
      {
        silent = true;
      }
    )
    (keymap "n" "gd" "<cmd>lua vim.lsp.buf.definition()<CR>" { silent = true; })
    (keymap "n" "gD" "<cmd>lua vim.lsp.buf.declaration()<CR>" {
      silent = true;
    })
    (keymap "n" "<leader>ld" "<cmd>lua vim.diagnostic.setqflist()<CR>" {
      silent = true;
    })
    (keymap "n" "]d" "<cmd>lua vim.diagnostic.goto_next()<CR>" { silent = true; })
    (keymap "n" "[d" "<cmd>lua vim.diagnostic.goto_prev()<CR>" { silent = true; })
  ];
  extraPackages = [
    pkgs.cargo
    pkgs.rustc
    pkgs.lldb
  ];
}
