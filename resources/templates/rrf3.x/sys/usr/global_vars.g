; All machine-global variables

{% from 'sys/usr/maybe_brush.g' import declare_global_maybe_brush_vars %}

{{ declare_global_maybe_brush_vars() }}

{% from 'sys/usr/prime.g' import declare_global_prime_vars %}

{{ declare_global_prime_vars() }}