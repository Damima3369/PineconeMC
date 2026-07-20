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

---

### 🚀 Установка

#### Вариант 1.1: Прямое использование через Flakes
Добавьте репозиторий в `inputs` вашего `flake.nix`:

```nix
inputs = {
  pineconemc = {
    url = "github:Damima3369/PineconeMC";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
````

И подключите пакет напрямую в `configuration.nix`:

```nix
environment.systemPackages = [
  inputs.pineconemc.packages.${pkgs.system}.default
];
```

#### Вариант 1.2: Подключение через Overlay (Рекомендуемый)

Добавьте репозиторий в `inputs` вашего `flake.nix`:

```nix
inputs = {
  pineconemc = {
    url = "github:Damima3369/PineconeMC";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Подключите оверлей в `outputs` вашего `flake.nix`:

```nix
outputs = { self, nixpkgs, pineconemc, ... }@inputs: {
  nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux"; # или "aarch64-linux"
    modules = [
      ./configuration.nix
      {
        nixpkgs.overlays = [ pineconemc.overlays.default ];
      }
    ];
  };
};
```

После этого пакет станет доступен в `pkgs`, и его можно добавить в `configuration.nix` максимально лаконично:

```nix
environment.systemPackages = with pkgs; [
  pineconemc
];
```

#### Вариант 2: Без Flakes (Классический NixOS)

Добавьте следующий импорт прямо в список пакетов вашего `configuration.nix`:

```nix
environment.systemPackages = [
  (import (builtins.fetchGit {
    url = "https://github.com/Damima3369/PineconeMC.git";
    ref = "main";
  }) { inherit pkgs; })
];
```

### ⚡ Быстрый запуск без установки

Попробовать лаунчер без добавления в систему:

```bash
nix run github:Damima3369/PineconeMC
```

## English

Unofficial Nix package for PineconeMC, built directly from the official AppImage. It allows you to easily integrate the launcher into your NixOS configuration with out-of-the-box support for all required Minecraft graphics libraries (LWJGL) and multiple Java runtime environments (8, 17, 21, 25).

### ⚠️ Disclaimer

- **I am NOT the creator or developer of this software fork.**
- This repository contains **only the packaging code (derivation)** for the NixOS operating system.
- I do not claim any copyrights, trademarks, or intellectual property rights belonging to the authors of the fork or the original Prism Launcher. All rights belong to their respective owners.
- This package is provided "as is", use it at your own risk.
### 🚀 Installation

#### Option 1.1: Direct Usage via Flakes

Add this repository to `inputs` in your `flake.nix`:

```nix
inputs = {
  pineconemc = {
    url = "github:Damima3369/PineconeMC";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Then add the package directly inside your `configuration.nix`:

```nix
environment.systemPackages = [
  inputs.pineconemc.packages.${pkgs.system}.default
];
```

#### Option 1.2: Clean Setup via Overlay (Recommended)

Add this repository to `inputs` in your `flake.nix`:

```nix
inputs = {
  pineconemc = {
    url = "github:Damima3369/PineconeMC";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Pass the overlay inside `outputs` of your `flake.nix`:

```mix
outputs = { self, nixpkgs, pineconemc, ... }@inputs: {
  nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux"; # or "aarch64-linux"
    modules = [
      ./configuration.nix
      {
        nixpkgs.overlays = [ pineconemc.overlays.default ];
      }
    ];
  };
};
```

Now `pineconemc` is injected into `pkgs`, allowing for a clean syntax in `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  pineconemc
];
```

#### Option 2: Legacy / Non-Flakes

Add this import directly to the package list in your `configuration.nix`:

```nix
environment.systemPackages = [
  (import (builtins.fetchGit {
    url = "https://github.com/Damima3369/PineconeMC.git";
    ref = "main";
  }) { inherit pkgs; })
];
```

### ⚡ Try Without Installing

Test the launcher on the fly without adding it to your system configuration:

```bash
nix run github:Damima3369/PineconeMC
```
