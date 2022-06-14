import godot
import macros
import godotapi/node

macro defineGetter*(t: typedesc): untyped =
  let procName = ident("get" & $t)
  result = quote do:
    template `procName`*(path: NodePath): `t` =
      # let nodePath = newNodePath(path)
      self.getNode(path) as `t`
