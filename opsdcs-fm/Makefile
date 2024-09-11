CXX = g++
CXXFLAGS = -std=c++14 -D ED_FM_TEMPLATE_EXPORTS

SOURCES = $(wildcard src/*.cpp) $(wildcard src/*/*.cpp)
OBJDIR_DEBUG = build/x64/Debug
OBJDIR_RELEASE = build/x64/Release
TARGET_DEBUG = build/x64/Debug/opsdcs-fm.dll
TARGET_RELEASE = build/x64/Release/opsdcs-fm.dll

all: debug

debug: CXXFLAGS += -DDEBUG -O0 -g -m64 -gcodeview
debug: LDFLAGS += -gcodeview -Wl,--pdb=$(OBJDIR_DEBUG)/opsdcs-fm.pdb
debug: $(TARGET_DEBUG)

release: CXXFLAGS += -DNDEBUG -O3 -m64
release: $(TARGET_RELEASE)

$(TARGET_DEBUG): $(patsubst %.cpp,$(OBJDIR_DEBUG)/%.o,$(SOURCES))
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -shared -o $@ $^

$(OBJDIR_DEBUG)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET_RELEASE): $(patsubst %.cpp,$(OBJDIR_RELEASE)/%.o,$(SOURCES))
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -shared -o $@ $^

$(OBJDIR_RELEASE)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -rf build
