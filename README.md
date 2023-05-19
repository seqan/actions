# SeqAn Actions

Collections of actions for CI running ci tools

## ToDo

* Split actions:
* * `setup_toolchain` (compiler, ccache, actions/cache)
* * `setup_doxygen` (doxygen)
* * `setup_cmake` (CMake)

* Export `CC` and `CXX` in `setup_toolchain`

* Question: Both doxygen and toolchain could use `configure_apt.sh`. How to deduplicate?
* * Maybe a `setup_package_manager` that can then be used in both actions.
* * Export an env variable that indicates wheter this action ran?
* * Could provide `install.sh`.
