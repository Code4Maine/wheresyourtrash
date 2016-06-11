# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2016-06-11 17:24
from __future__ import unicode_literals
from django.core.management import call_command

from django.db import migrations, models

fixture = 'initial_data'

def load_fixture(apps, schema_editor):
    call_command('loaddata', fixture, app_label='email2sms')

def unload_fixture(apps, schema_editor):
    "Deleting all entries for this model..."
    Provider = apps.get_model("email2sms", "Provider")
    Provider.objects.all().delete()

class Migration(migrations.Migration):

    dependencies = [
        ('email2sms', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(load_fixture, reverse_code=unload_fixture),
    ]
