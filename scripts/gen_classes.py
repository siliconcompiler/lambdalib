import argparse
import os
from jinja2 import Environment, FileSystemLoader
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description="""\
    Generates boiler plate lambalib design classes
    """, formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument("group", help="Group name")
    parser.add_argument("-name", help="Design name")

    args = parser.parse_args()

    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template('template.py.j2')

    lib = "../lambdalib"

    if args.name:
        lb_list = [args.name]
    else:
        base = Path(lib) / args.group
        paths = [p for p in base.iterdir() if p.is_dir()]
        lb_list = [os.path.basename(item) for item in paths]

    for item in lb_list:

        context = {
            'class_name': item[3:],
            'module_name': item
        }
        output = template.render(context)
        filename = f"{lib}/{args.group}/{item}/{item}.py"
        with open(filename, 'w') as f:
            f.write(output)
            f.write("\n")


if __name__ == "__main__":
    main()
