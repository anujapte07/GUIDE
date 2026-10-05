def adder4bit_golden(a, b):
    """Reference model of a 4-bit unsigned adder with carry-out."""
    total = (a & 0xF) + (b & 0xF)          # full-precision unsigned sum (0..30)
    return {'sum': total & 0xF,            # lower 4 bits
            'carry': 1 if total > 15 else 0}