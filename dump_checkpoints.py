from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import argparse
import json
import os
import re
import string
import tensorflow as tf

FILENAME_CHARS = string.ascii_letters + string.digits + '_'

def _var_name_to_filename(var_name):
  chars = []
  for c in var_name:
    if c in FILENAME_CHARS:
      chars.append(c)
    elif c == '/':
      chars.append('_')
  return ''.join(chars)

def remove_optimizer_variables(output):
  vars_dir = os.path.expanduser(output)
  manifest_file = os.path.join(output, 'manifest.json')
  with open(manifest_file) as f:
    manifest = json.load(f)
  new_manifest = {key: manifest[key] for key in manifest 
  if 'Adam' not in key and 'beta' not in key}
  with open(manifest_file, 'w') as f:
    json.dump(new_manifest, f, indent=2, sort_keys=True)

  for name in os.listdir(output):
    if 'Adam' in name or 'beta' in name:
      os.remove(os.path.join(output, name))

def dump_checkpoints(checkpoint_dir, output):
  chk_fpath = os.path.expanduser(checkpoint_dir)
  reader = tf.train.NewCheckpointReader(chk_fpath)
  var_to_shape_map = reader.get_variable_to_shape_map()
  output_dir = os.path.expanduser(output)
  tf.gfile.MakeDirs(output_dir)
  manifest = {}
  remove_vars_compiled_re = re.compile('')

  var_filenames_strs = []
  for name in var_to_shape_map:
    if ('' and
        re.match(remove_vars_compiled_re, name)) or name == 'global_step':
      continue
    var_filename = _var_name_to_filename(name)
    manifest[name] = {'filename': var_filename, 'shape': var_to_shape_map[name]}

    tensor = reader.get_tensor(name)
    with open(os.path.join(output_dir, var_filename), 'wb') as f:
      f.write(tensor.tobytes())

    var_filenames_strs.append("\"" + var_filename + "\"")

  manifest_fpath = os.path.join(output_dir, 'manifest.json')
  print('Writing manifest to ' + manifest_fpath)
  with open(manifest_fpath, 'w') as f:
    f.write(json.dumps(manifest, indent=2, sort_keys=True))

  remove_optimizer_variables(output_dir)
