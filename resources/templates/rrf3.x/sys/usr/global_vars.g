; All machine-global variables

{% from 'sys/usr/maybe_brush.g' import declare_global_maybe_brush_vars %}
{% from 'sys/usr/prime.g' import declare_global_prime_vars %}
{% from '__macros__/babystep.jinja' import declare_global_babystep_vars %}
{% import 'sys/usr/lib/xyz_stack.g' as xyz_stack %}

{{ declare_global_maybe_brush_vars() }}

{{ declare_global_prime_vars() }}

{{ declare_global_babystep_vars() }}
