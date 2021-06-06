#!/usr/bin/env python3

import sys
import csv
import os
import tldextract
import subprocess


class Record:
    def __init__(self, row):
        self.url = row[0]
        self.username = row[1]
        self.password = row[2]
        self.totp = row[3]
        self.extra = row[4]
        self.name = row[5]

    def name():
        return self.name

    def __str__(self):
        s = self.password + "\n---\n"
        s += self.name + "\n"

        if self.username:
            s += "username: %s\n" % self.username

        if self.password:
            s += "password: %s\n" % self.password

        if self.url:
            s += "url: %s\n" % self.url

        if self.extra:
            s += self.extra

        return s


def main():
    if len(sys.argv) < 2:
        print("Please the full path to the Lastpass CSV.")
        exit()

    script = sys.argv[0]
    lastpass_csv = sys.argv[1]

    if not os.path.isfile(lastpass_csv):
        print("Lastpass CSV file not found at %s" % lastpass_csv)
        exit()

    with open(lastpass_csv) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=",")
        line_count = 0
        records = []

        for row in csv_reader:
            if line_count == 0:
                # print(f'Column names are {", ".join(row)}')
                line_count += 1
            else:
                line_count += 1
                records.append(Record(row))
                # print(f'Processed {line_count} lines.')

    basepath = "/Users/ifor/.password-store/temp/"
    print(f"Found {len(records)} records.")
    record_no = 0
    for record in records:
        url = record.url
        extract = tldextract.extract(url)
        dirname = (extract.domain + "." + extract.suffix).lstrip(".")
        filepath = dirname
        filepath = filepath.rstrip(".") + "/"

        filename = ""
        if extract.subdomain and extract.subdomain != "www":
            filename += extract.subdomain + "."

        if extract.domain:
            filename += extract.domain + "."

        if extract.suffix:
            filename += extract.suffix

        website = filename.strip(".")
        record_name = website + "/" + record.username

#         if os.path.isfile(basepath + filepath + filename + ".gpg"):
#             filename += "_" + str(record_no)

        # print(filepath, filename)

        cmd = f"pass insert -m {record_name}"
        print(cmd)
        # continue
        result = subprocess.run(
            cmd,
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            input=str(record).encode("utf-8"),
        )
        print(result.stdout.decode("utf-8"))

        record_no += 1


if __name__ == "__main__":
    main()
