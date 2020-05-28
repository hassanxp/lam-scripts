import sys
import numpy as np
from astropy.io import fits

hdul = fits.open(sys.argv[1])
data = hdul[1].data
print(f'data shape: {data.shape}')
print(f'is all data NaN: {np.all(np.isnan(data))}')
print(f'data = {data}')
