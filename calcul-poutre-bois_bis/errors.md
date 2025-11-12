# Errors in current dir

## current dir

`tree /F /A | Out-File -Encoding UTF8 file_listing.md` :

- calcul_eurocode.py
- errors.md
- file_listing.md
- generate_typst.py
- orchestrateur.py
- poutre_001.toml
- test.typ


## `calcul_eurocode.py` errors


PS C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis> python calcul_eurocode.py poutre_001.toml
Traceback (most recent call last):
  File "C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis\calcul_eurocode.py", line 178, in <module>
    if len(sys.argv) < 2:
           ^^^
NameError: name 'sys' is not defined. Did you forget to import 'sys'?

---


[{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/calcul_eurocode.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« pd » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 164,
	"startColumn": 26,
	"endLineNumber": 164,
	"endColumn": 28,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/calcul_eurocode.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 178,
	"startColumn": 12,
	"endLineNumber": 178,
	"endColumn": 15,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/calcul_eurocode.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 180,
	"startColumn": 9,
	"endLineNumber": 180,
	"endColumn": 12,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/calcul_eurocode.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 182,
	"startColumn": 31,
	"endLineNumber": 182,
	"endColumn": 34,
	"origin": "extHost2"
}]


## `generate_typst.py` errors

PS C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis> python generate_typst.py poutre_001.toml 
C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis\generate_typst.py:174: SyntaxWarning: invalid escape sequence '\s'
  
Traceback (most recent call last):
  File "C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis\generate_typst.py", line 188, in <module>
    main()
    ~~~~^^
  File "C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis\generate_typst.py", line 181, in main
    if len(sys.argv) < 4:
           ^^^
NameError: name 'sys' is not defined. Did you forget to import 'sys'?

---

[{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/generate_typst.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« ELU » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 119,
	"startColumn": 53,
	"endLineNumber": 119,
	"endColumn": 56,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/generate_typst.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« self » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 132,
	"startColumn": 20,
	"endLineNumber": 132,
	"endColumn": 24,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/generate_typst.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 181,
	"startColumn": 12,
	"endLineNumber": 181,
	"endColumn": 15,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/generate_typst.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 183,
	"startColumn": 9,
	"endLineNumber": 183,
	"endColumn": 12,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/generate_typst.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 185,
	"startColumn": 27,
	"endLineNumber": 185,
	"endColumn": 30,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/generate_typst.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 185,
	"startColumn": 40,
	"endLineNumber": 185,
	"endColumn": 43,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/generate_typst.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« sys » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 185,
	"startColumn": 53,
	"endLineNumber": 185,
	"endColumn": 56,
	"origin": "extHost2"
}]



## `orchestrateur.py` errors

C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis> python orchestrateur.py poutre_001.toml 

🚀 Traitement de poutre_001.toml
1️⃣ Calculs Eurocode...
Traceback (most recent call last):
  File "C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis\calcul_eurocode.py", line 178, in <module>
    if len(sys.argv) < 2:
           ^^^
NameError: name 'sys' is not defined. Did you forget to import 'sys'?
Traceback (most recent call last):
  File "C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis\orchestrateur.py", line 47, in <module>
    workflow_complet(f)
    ~~~~~~~~~~~~~~~~^^^
  File "C:\Users\oturl\Documents\geeks\Typst-tries\calcul-poutre-bois_bis\orchestrateur.py", line 15, in workflow_complet
    subprocess.run(["python", "calcul_eurocode.py", toml_file], check=True)
    ~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "C:\Users\oturl\AppData\Local\Programs\Python\Python313\Lib\subprocess.py", line 577, in run
    raise CalledProcessError(retcode, process.args,
                             output=stdout, stderr=stderr)
subprocess.CalledProcessError: Command '['python', 'calcul_eurocode.py', 'poutre_001.toml']' returned non-zero exit status 1.

---

[{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« pd » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 19,
	"startColumn": 17,
	"endLineNumber": 19,
	"endColumn": 19,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 20,
	"startColumn": 5,
	"endLineNumber": 20,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 21,
	"startColumn": 5,
	"endLineNumber": 21,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 22,
	"startColumn": 5,
	"endLineNumber": 22,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 23,
	"startColumn": 5,
	"endLineNumber": 23,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 24,
	"startColumn": 5,
	"endLineNumber": 24,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 25,
	"startColumn": 5,
	"endLineNumber": 25,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 26,
	"startColumn": 5,
	"endLineNumber": 26,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 27,
	"startColumn": 5,
	"endLineNumber": 27,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 28,
	"startColumn": 5,
	"endLineNumber": 28,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« plt » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 29,
	"startColumn": 5,
	"endLineNumber": 29,
	"endColumn": 8,
	"origin": "extHost2"
},{
	"resource": "/c:/Users/oturl/Documents/geeks/Typst-tries/calcul-poutre-bois_bis/orchestrateur.py",
	"owner": "Pylance11",
	"code": {
		"value": "reportUndefinedVariable",
		"target": {
			"$mid": 1,
			"path": "/microsoft/pylance-release/blob/main/docs/diagnostics/reportUndefinedVariable.md",
			"scheme": "https",
			"authority": "github.com"
		}
	},
	"severity": 4,
	"message": "« generate_typst_report » n’est pas défini",
	"source": "Pylance",
	"startLineNumber": 33,
	"startColumn": 5,
	"endLineNumber": 33,
	"endColumn": 26,
	"origin": "extHost2"
}]