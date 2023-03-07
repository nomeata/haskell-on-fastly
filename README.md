Haskell on Fastly experiments
=============================

This repo contains an experiment with compiling Haskell to WebAssembly and
runnig it on fastly’s Compute@Cloud service.

See it in action on <https://haskell-on-fastly.edgecompute.app/>

Moving parts
------------

 * Haskell's GHC compiler supports compiling to WebAssembly since GHC-9.8.
   This repo is using <https://gitlab.haskell.org/ghc/ghc-wasm-meta> to get a
   precompiled compiler for that target (see <./flake.nix>)

 * The generated code uses the WASI system interface (<https://wasi.dev/>) for
   generic stuff (accessing environment variables). Luckily, Fastly's
   platform builds on that.

 * The Fastly specific stuff (access to the request, sending out the response)
   is exposed via additional WebAssembly functions. This “ABI” is not fully
   document, but one can gather how they use from

   - The low-level Rust Crate: <https://docs.rs/fastly-sys>
   - The high-level Rust Crate: <https://docs.rs/fastly>
   - A interface description in witx format:
     <https://github.com/fastly/Viceroy/blob/main/lib/compute-at-edge-abi/compute-at-edge.witx>
   - The host-side implementation in Viceroy, the local development environment:
     <https://github.com/fastly/Viceroy/tree/05247c4addbd94b04636ff89c0a89fbaf672b2e9/lib/src/wiggle_abi>

   We bind a few of function via Haskell's FFI in file <./Fastly.hs>. Because
   Haskell's WebAssembly FFI currently does not support importing functions
   from a different WebAssembly module than `env`, file <./fastly-sys.c>
   imports them from the right module and wraps them in a “local” C function
   that we can import from Haskell

How to build, test and deploy
-----------------------------

1. [Install nix](https://nix.dev/tutorials/install-nix)
2. Enter a nix shell using `nix develop`. You now have tools like `fastly`,
   `viceroy` and especially `wasm32-wasi-ghc` available.
3. Compile using
   ```
   wasm32-wasi-ghc --make fastly-sys.c hello.hs
   ```
4. Run locally with
   ```
   viceroy -v hello.wasm
   ```
5. Deploy using `fastly compute build && fastly compute deploy`, after setting
   up the `fastly` instance.

Status
------

This is just a small demo. It supports

* Reading method and URI from the request
* Adding headers and body to the response

There is still much

TODO
----

* Cover more of the Fastly API

  Mostly tediuos work, and in the bright future something like the [WASM
  Component model](https://github.com/WebAssembly/component-model) will make
  that much easier.

* Be compatible with [WAI](https://hackage.haskell.org/package/wai). This would
  allow us to compile any WAI-compatible Web application to run on Fastly.

  Should not be hard, but I got stuck with the `unix` package not compiling on
  this target yet. So best to wait for the Haskell-on-WebAssembly eco system to
  mature a bit more.

* Optimize (mabye disable GC, maybe pre-evaluate the binary using
  [wizer](https://github.com/bytecodealliance/wizer)).

Contributions are welcome!

Credits
=======

Thanks to Cheng Shao aKa TerrorJack for his work on GHC-to-WebAssembly and help
with these experiments.

