(* Copyright (c) 1998 by Lucent Technologies 
 * pretty-printer which simply ignores any aidinfo.
 *)

local 
  structure PPAstAdornment : PPASTADORNMENT =
  struct
    type aidinfo = unit

    fun ppExpressionAdornment ppCoreExpr aidinfo tidtab pps (Ast.EXPR (coreExpr,_,_)) = 
	ppCoreExpr aidinfo tidtab pps coreExpr

    fun ppStatementAdornment ppCoreStmt aidinfo tidtab pps  (Ast.STMT (coreStmt,_,_)) = 
	ppCoreStmt aidinfo tidtab pps coreStmt

    fun ppExternalDeclAdornment ppCoreExternalDecl aidinfo tidtab pps
	  (Ast.DECL (coreExtDecl,_,_)) = 
	ppCoreExternalDecl aidinfo tidtab pps coreExtDecl

    fun ppExternalDeclAdornment srcFileOpt ppCoreExternalDecl aidinfo tidtab pps
          (Ast.DECL (coreExtDecl,_,loc:SourceMap.location)) =
          (case loc of SourceMap.UNKNOWN => ppCoreExternalDecl aidinfo tidtab pps coreExtDecl
           | SourceMap.LOC r => let val fname = OS.Path.file (#srcFile r) (* Hancock *)
                                    val forCKitOnly = case OS.Path.splitDirFile fname
					of {dir, file} => 
					    (file = "ckit-typechecking.h" orelse file="OSByteOrder.h")
                                 in
                                     case srcFileOpt
                                     of NONE => ppCoreExternalDecl aidinfo tidtab pps coreExtDecl
                                     |  SOME srcname =>
                                         if forCKitOnly
                                         then ()
                                         else ppCoreExternalDecl aidinfo tidtab pps coreExtDecl
                                 end)

  end

in
  structure PPAst = PPAstFn(structure PPAstAdornment=PPAstAdornment)
end
