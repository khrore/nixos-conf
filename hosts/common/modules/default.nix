{ mylib, system, ... }:
{
  imports = [
    ./shared
  ]
  ++ (if mylib.isLinux system then [ ./nixos ] else [ ])
  ++ (if mylib.isDarwin system then [ ./darwin ] else [ ]);
}
