# blink-go-import.nvim

An go import packages source for [blink.cmp](https://github.com/Saghen/blink.cmp).

https://github.com/user-attachments/assets/911b88f2-7473-4050-af7d-a6b79e79f094


## 🔨 Installation

### 💤 lazy.nvim
```lua
{
  "saghen/blink.cmp",
  dependencies = {
        "edte/blink-go-import.nvim",
        ft = "go",
        config = function()
            require("blink-go-import").setup()
        end
  },
  opts = {
    sources = {
      default = {
        ...
        "go_pkgs",
      },
      providers = {
        go_pkgs = {
          module = "blink-go-import",
          name = "Import",
        }
      }
    }
  }
}
```

## 📘 Usage
Just enter package name you whant in the import ()

## 💪 Credit
Based on [Snikimonkd/cmp-go-pkgs](https://github.com/Snikimonkd/cmp-go-pkgs).

## 📜 License
See [License](./LICENSE).
