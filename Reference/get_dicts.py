from tabula.io import read_pdf
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df  = pd.read_html('http://adni.loni.usc.edu/data-samples/adni-data-inventory/')
df = pd.DataFrame(df[0])
adni_inv = df.iloc[:, 0:3]
adni_inv.to_csv('adni_inv.csv', index=False)
