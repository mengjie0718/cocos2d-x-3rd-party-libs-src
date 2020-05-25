# bullet

GLSLOPT_GITURL := https://gitee.com/mengjie0718/glsl-optimizer.git

$(TARBALLS)/glsl-optimizer-git.tar.xz:
	$(call download_git,$(GLSLOPT_GITURL),master)

.sum-glslopt: glsl-optimizer-git.tar.xz
	$(warning $@ not implemented)
	touch $@

glsl_optimizer: glsl-optimizer-git.tar.xz .sum-glslopt
	$(UNPACK)
	$(APPLY) $(SRC)/glsl_optimizer/remove_targets.patch
	$(MOVE)

.glsl_optimizer: glsl_optimizer toolchain.cmake
	cd $< && $(HOSTVARS) CXXFLAGS="$(CXXFLAGS) $(EX_ECFLAGS)" CFLAGS="$(CFLAGS) $(EX_ECFLAGS)" $(CMAKE) -DCMAKE_BUILD_TYPE=Release $(make_option) 
	cd $< && $(MAKE) -j 6
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
