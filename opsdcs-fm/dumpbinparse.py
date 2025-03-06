# Usage:
# pip install git+https://github.com/wbenny/pydemangler.git
# dumpbin /export CockpitBase.dll > dump.txt
# python dumpbinparse.py < dump.txt > could_not_parse.txt
#
# output goes to headers/ folder

import sys
import os
import re
import pydemangler

headers = {}

pattern = re.compile(
    r"(?P<access>public|protected|private)?:?\s*"
    r"(?P<static>static\s+)?"
    r"(?P<virtual>virtual\s+)?"
    r"(?P<return_type>[\w:<>&* \t]+)?\s*"
    r"(?P<calling>\b__\w+\b)\s+"
    r"(?P<full_class>(?:\w+::)*\w+)::"
    r"(?P<func_name>\w+)\((?P<parameters>.*)\)"
)

def clean_function_signature(signature):
    signature = re.sub(r"\b(class|struct) ", "", signature)
    signature = re.sub(r"\b(\w+)\s+\*\s*(\w+)", r"\1* \2", signature)
    return signature.strip()

for line in sys.stdin:
    mangled_name = line.strip()
    demangled_name = pydemangler.demangle(mangled_name)
    if not demangled_name:
        print(f'/* UNKNOWN FORMAT */ {mangled_name}')
        continue
    match = pattern.match(demangled_name)
    if not match:
        print(f'/* UNKNOWN FORMAT */ {demangled_name}')
        continue

    access = match.group("access") or "public"
    static = match.group("static") or ""
    virtual = match.group("virtual") or ""
    return_type = match.group("return_type")
    calling_convention = match.group("calling")
    full_class = match.group("full_class")
    func_name = match.group("func_name")
    parameters = match.group("parameters").strip()
    cleaned_return_type = clean_function_signature(return_type or "")
    cleaned_parameters = parameters if parameters else "void"
    parts = full_class.split("::")
    namespace = "::".join(parts[:-1]) if len(parts) > 1 else "global"
    class_name = parts[-1]
    filename = f"{namespace.replace('::', '_')}_{class_name}.h"
    file_path = os.path.join("headers", filename)
    function_declaration = f"    {static}{virtual}{cleaned_return_type} {calling_convention} {func_name}({cleaned_parameters});"

    if file_path not in headers:
        headers[file_path] = {
            "namespace": namespace,
            "class": class_name,
            "public": [],
            "protected": []
        }
    if access == "public":
        headers[file_path]["public"].append(function_declaration)
    elif access == "protected":
        headers[file_path]["protected"].append(function_declaration)

os.makedirs("headers", exist_ok=True)

for file_path, data in headers.items():
    with open(file_path, "w") as f:
        guard = file_path.replace("/", "_").replace(".", "_").upper()
        f.write(f"#ifndef {guard}\n#define {guard}\n\n")
        if data["namespace"] != "global":
            f.write(f"namespace {data['namespace']} {{\n\n")
        f.write(f"class {data['class']} {{\n")
        if data["public"]:
            f.write("public:\n")
            f.write("\n".join(data["public"]) + "\n")
        if data["protected"]:
            f.write("protected:\n")
            f.write("\n".join(data["protected"]) + "\n")
        f.write("};\n\n")
        if data["namespace"] != "global":
            f.write(f"}} // namespace {data['namespace']}\n")
        f.write(f"#endif // {guard}\n")
