#!/bin/bash

sudo docker-compose up -d --build && sudo docker-compose logs -f --tail 100

