# NixOS Package for PineconeMC (ex. ElyPrismLauncher)

[Русский](#русский) | [English](#english)

---

## Русский

Неофициальный Nix-пакет для PineconeMC, собранный из AppImage. Позволяет легко встроить лаунчер в конфигурацию NixOS с автоматической поддержкой всех необходимых для Minecraft графических библиотек (LWJGL) и версий Java (8, 17, 21, 25).

### ⚠️ Дисклеймер / Отказ от ответственности

* **Я НЕ являюсь создателем или разработчиком данного форка программы.**
* Данный репозиторий содержит **исключительно код сборки (рецепт) пакета** для операционной системы NixOS.
* Я не претендую на авторские права, торговые марки или интеллектуальную собственность авторов форка или оригинального Prism Launcher. Все права принадлежат их законным владельцам.
* Продукт распространяется «как есть», используйте на свой страх и риск.

### 🚀 Установка

#### Вариант 1: Использование Flakes
Добавьте репозиторий в ваш `flake.nix`:
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  pineconemc.url = "github:Damima3369/PineconeMC";
};
```

И добавьте пакет в систему внутри `configuration.nix`:

```Nix
environment.systemPackages = [
  inputs.pineconemc.packages.${pkgs.system}.default
];
```

#### Вариант 2: Без Flakes (Классический)

Добавьте следующий импорт прямо в список пакетов вашего `configuration.nix`:

```Nix
environment.systemPackages = [
  (import (builtins.fetchGit {
    url = "https://github.com/Damima3369/PineconeMC.git";
    ref = "main";
  }) { inherit pkgs; })
];
```

## English

Unofficial Nix package for a PineconeMC, built from AppImage. It allows you to easily integrate the launcher into your NixOS configuration with out-of-the-box support for all required Minecraft graphics libraries (LWJGL) and multiple Java versions (8, 17, 21, 25).

### ⚠️ Disclaimer

- **I am NOT the creator or developer of this software fork.**
- This repository contains **only the packaging code (derivation)** for the NixOS operating system.
- I do not claim any copyrights, trademarks, or intellectual property rights belonging to the authors of the fork or the original Prism Launcher. All rights belong to their respective owners.
- This is provided "as is", use it at your own risk.

### 🚀 Installation

#### Option 1: Using Flakes

Add this repository to your `flake.nix`:

```Nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  pineconemc.url = "github:Damima3369/PineconeMC";
};
```

Then add the package to your system inside `configuration.nix`:

```Nix
environment.systemPackages = [
  inputs.pineconemc.packages.${pkgs.system}.default
];
```

#### Option 2: Legacy / Without Flakes

Add this import directly to the packages list in your `configuration.nix`:

```Nix
environment.systemPackages = [
  (import (builtins.fetchGit {
    url = "https://github.com/Damima3369/PineconeMC.git";
    ref = "main";
  }) { inherit pkgs; })
];
```
