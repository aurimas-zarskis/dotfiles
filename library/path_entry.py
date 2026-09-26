#!/usr/bin/python

DOCUMENTATION = r'''
---
module: path_entry
short_description: Manage modular Zsh PATH entries in paths.d
description:
  - Creates, updates, or deletes modular .zsh files in ~/.config/zsh/paths.d/
    to manage $PATH additions cleanly.
options:
  name:
    description:
      - The identifier or filename for the path configuration (e.g. 'android', 'go', 'cargo').
      - Automatically appends '.zsh' extension if not provided.
    required: true
    type: str
  paths:
    description:
      - List of directory paths to add to $PATH.
    required: false
    type: list
    elements: str
    default: []
  state:
    description:
      - Whether the path snippet should exist ('present') or be removed ('absent').
    choices: ['present', 'absent']
    default: present
    type: str
  dest_dir:
    description:
      - Custom directory to store snippet files in. Defaults to ~/.config/zsh/paths.d.
    required: false
    type: str
'''

EXAMPLES = r'''
- name: Add Android SDK to PATH
  path_entry:
    name: android
    paths:
      - "{{ ansible_facts['user_dir'] }}/Library/Android/sdk/platform-tools"
      - "{{ ansible_facts['user_dir'] }}/Library/Android/sdk/emulator"

- name: Remove outdated CLI from PATH
  path_entry:
    name: legacy_tool
    state: absent
'''

import os
from pathlib import Path

from ansible.module_utils.basic import AnsibleModule


def main():
    module = AnsibleModule(
        argument_spec={
            "name": {"type": "str", "required": True},
            "paths": {"type": "list", "elements": "str", "default": []},
            "state": {"type": "str", "choices": ["present", "absent"], "default": "present"},
            "dest_dir": {"type": "str", "required": False},
        },
        supports_check_mode=True,
    )

    name = module.params["name"].strip()
    paths = module.params["paths"]
    state = module.params["state"]
    custom_dest = module.params.get("dest_dir")

    filename = name if name.endswith(".zsh") else f"{name}.zsh"

    if custom_dest:
        target_dir = Path(os.path.expanduser(custom_dest))
    else:
        target_dir = Path.home() / ".config" / "zsh" / "paths.d"

    target_file = target_dir / filename

    if state == "absent":
        if target_file.exists():
            if not module.check_mode:
                try:
                    target_file.unlink()
                except OSError as e:
                    module.fail_json(msg=f"Failed to delete {target_file}: {e}")
            module.exit_json(
                changed=True,
                msg=f"Removed {target_file}",
                diff={"before": f"File {target_file} existed\n", "after": ""},
            )
        module.exit_json(changed=False, msg=f"{target_file} does not exist")

    # state == 'present'
    lines = [f"# Managed by Ansible - {name}"]
    for p in paths:
        clean_p = os.path.expanduser(p.strip())
        lines.append(f'path+=("{clean_p}")')
    content = "\n".join(lines) + "\n"

    existing_content = ""
    file_exists = target_file.exists()

    if file_exists:
        try:
            existing_content = target_file.read_text(encoding="utf-8")
        except OSError as e:
            module.fail_json(msg=f"Failed to read existing {target_file}: {e}")

        if existing_content == content:
            module.exit_json(changed=False, msg="Path configuration is up to date")

    # Needs change
    diff = {
        "before": existing_content if file_exists else "",
        "after": content,
    }

    if not module.check_mode:
        try:
            target_dir.mkdir(parents=True, exist_ok=True)
            target_file.write_text(content, encoding="utf-8")
            target_file.chmod(0o644)
        except OSError as e:
            module.fail_json(msg=f"Failed to write {target_file}: {e}")

    module.exit_json(
        changed=True,
        msg=f"Successfully configured {target_file}",
        diff=diff,
    )


if __name__ == "__main__":
    main()
