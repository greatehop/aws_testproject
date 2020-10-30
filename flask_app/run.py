#!/usr/bin/env python
# -*- coding: utf-8 -*-


import time

import settings
from app import daemon_app
from app.daemon import AppDaemon


if __name__ == '__main__':

    daemon = AppDaemon()
    # run daemon in background
    daemon.start()

    # delay to avoid uninitialized vars in WebUI
    time.sleep(settings.init_timeout)

    # run WebUI/API
    daemon_app.run(**settings.flask_args)
