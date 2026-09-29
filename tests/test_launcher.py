import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
MATCH = re.search(r"command: (\[.*\])", (ROOT / "Panel.qml").read_text())
ARGV = json.loads(MATCH.group(1))

class LauncherTests(unittest.TestCase):
    def execute(self, body=None):
        with tempfile.TemporaryDirectory() as folder:
            env = dict(os.environ, PATH=folder, DOT_ARGS=folder + "/args")
            if body is not None:
                helper = Path(folder) / "omarchy-launch-webapp"
                helper.write_text("#!/bin/bash\n" + body)
                helper.chmod(0o755)
            result = subprocess.run(["/bin/bash", *ARGV[1:]], env=env, capture_output=True)
            args_path = Path(env["DOT_ARGS"])
            return result.returncode, args_path.read_text() if args_path.exists() else None

    def test_missing_dependency(self):
        self.assertEqual(self.execute()[0], 127)

    def test_launches_only_dot(self):
        code, arguments = self.execute('printf "%s\\n" "$@" > "$DOT_ARGS"\n')
        self.assertEqual(code, 0)
        self.assertEqual(arguments, "https://chatgpt.com/dots\n")

    def test_failure_propagates(self):
        self.assertEqual(self.execute("exit 23\n")[0], 23)

if __name__ == "__main__":
    unittest.main()
