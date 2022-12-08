###############################################################################
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
###############################################################################
__version__ = "0.0.1"

import logging
import subprocess
from pathlib import Path
from pygeoapi.process.base import BaseProcessor, ProcessorExecuteError

LOGGER = logging.getLogger(__name__)

PROCESS_METADATA = {
    "version": "0.0.1",
    "id": "opencdms_backup",
    "title": {
        "en": "OpenCDMS Backup",
    },
    "description": {
        "en": "This pygeoapi process helps set up periodic backup jobs.",
    },
    "keywords": [],
    "links": [
        {
            "type": "text/html",
            "rel": "about",
            "title": "information",
            "href": "https://example.org/process",
            "hreflang": "en-US",
        }
    ],
    "inputs": {
        "db_host": {
            "title": "Database host",
            "description": "Database host url.",
            "schema": {"type": "string"},
            "minOccurs": 1,
            "maxOccurs": 1,
            "metadata": None,
            "keywords": [],
        },
        "db_port": {
            "title": "Database port",
            "description": "Port where database connection is exposed.",
            "schema": {"type": "integer"},
            "minOccurs": 1,
            "maxOccurs": 1,
            "metadata": None,
            "keywords": [],
        },
        "db_user": {
            "title": "Database username",
            "description": "User with proper role to take backup of database.",
            "schema": {"type": "string"},
            "minOccurs": 1,
            "maxOccurs": 1,
            "metadata": None,
            "keywords": [],
        },
        "db_pass": {
            "title": "Database password",
            "description": "Password for the given user.",
            "schema": {"type": "string"},
            "minOccurs": 1,
            "maxOccurs": 1,
            "metadata": None,
            "keywords": [],
        },
        "output_dir": {
            "title": "Output directory",
            "description": "Directory where backup file should be stored.",
            "schema": {"type": "string"},
            "minOccurs": 1,
            "maxOccurs": 1,
            "metadata": None,
            "keywords": [],
        },
        "cron_expression": {
            "title": "CRON expression",
            "description": (
                "Optional cron expression to set up periodic job. If not"
                " provided, the backup job will run everyday at midnight"
                " (UTC)."
            ),
            "schema": {"type": "string"},
            "minOccurs": 0,
            "maxOccurs": 1,
            "metadata": None,
            "keywords": [],
        },
    },
    "outputs": {
        "message": {
            "title": "Job execution status",
            "schema": {"type": "string"},
        }
    },
    "example": {
        "inputs": {
            "db_host": "127.0.0.1",
            "db_port": 25432,
            "db_user": "postgres",
            "db_pass": "password",
            "output_dir": "/home/faysal/PycharmProjects/opencdms-backup",
        }
    },
}


class OpenCDMSBackup(BaseProcessor):
    def __init__(self, processor_def):
        """
        Initialize object
        :param processor_def: provider definition
        :returns: pygeoapi.process.opencdms_backup.OpenCDMSBackup
        """

        super().__init__(processor_def, PROCESS_METADATA)

    def execute(self, data):
        mimetype = "application/json"
        try:
            db_host = data["db_host"]
            db_port = data["db_port"]
            db_user = data["db_user"]
            db_pass = data["db_pass"]
            output_dir = data["output_dir"]
            cron_expression = data.get("cron_expression", "00 00 * * *")
            project_root = Path(".").parent.resolve()
            commands = [
                ["sh", "-c", "crontab -l > tmp_cron"],
                [
                    "sh",
                    "-c",
                    (
                        f'echo "{cron_expression} {project_root}/backup-db.sh'
                        f' {db_host} {db_port} {db_user} {db_pass} {output_dir}"'
                        " >> tmp_cron"
                    ),
                ],
                ["crontab", "tmp_cron"],
                ["rm", "tmp_cron"],
            ]

            output = {"message": "Backup job scheduled successfully."}

            for command in commands:
                process = subprocess.Popen(
                    command, stdout=subprocess.PIPE, stderr=subprocess.PIPE
                )
                stdout, stderr = process.communicate()
                logging.info(stdout.decode("utf-8"))
                logging.info(stderr.decode("utf-8"))
                if stderr:
                    output = {"message": "Failed scheduling backup job."}
                    break

        except KeyError as e:
            output = {"message": f"Required field: {str(e)}"}

        return mimetype, output

    def __repr__(self):
        return "<OpenCDMSBackup> {}".format(self.name)
