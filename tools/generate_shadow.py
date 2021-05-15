import sys
if sys.version_info[0] < 3:
    raw_input("You need to run this with Python 3!\nPress Enter to exit...")
    sys.exit(1)

try:
    from passlib import hash
except ImportError:
    print("  You are missing the passlib module!\n"
          "  install it by running: \n"
          "  pip install passlib")
    input("\nPress Enter to exit...")
    sys.exit(1)

password = input("Enter password: ")
shadow_hash = hash.des_crypt.hash(password)
password = input("Confirm password: ")
if (hash.des_crypt.verify(password, shadow_hash)):
    f = open('shadow', 'wb')
    f.write(b'root:' + bytearray(shadow_hash, "ascii") + b':98:0:0\x0A')
    f.close()
    print("shadow file is successfully generated")
    input("\nPress Enter to exit...")
else:
    print("ERROR: passwords do not match!")
    input("\nPress Enter to exit...")