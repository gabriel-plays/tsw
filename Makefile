# The Mire End Cycle — build system
#
# Usage:
#   make                       Build the default product (set below)
#   make build PRODUCT=<dir>   Build a specific product
#   make all                   Build every product in products/
#   make list                  List available products
#   make watch PRODUCT=<dir>   Rebuild on manuscript changes (needs entr)
#   make clean                 Remove all build artifacts
#   make check                 Verify dependencies are installed

PRODUCT ?= 01-the-salt-wedding

PANDOC      := pandoc
PDF_ENGINE  := xelatex
TEMPLATE    := shared/template/template.tex

PRODUCT_DIR    := products/$(PRODUCT)
MANUSCRIPT     := $(PRODUCT_DIR)/manuscript.md
METADATA       := $(PRODUCT_DIR)/metadata.yaml
BUILD_DIR      := $(PRODUCT_DIR)/build
OUTPUT_PDF     := $(BUILD_DIR)/$(PRODUCT).pdf

PANDOC_FLAGS := \
	--from=markdown+smart+yaml_metadata_block \
	--metadata-file=$(METADATA) \
	--template=$(TEMPLATE) \
	--pdf-engine=$(PDF_ENGINE) \
	--pdf-engine-opt=-output-directory=$(BUILD_DIR) \
	--variable=lang:en-GB \
	--top-level-division=section

.PHONY: default build all list watch clean check help install-fonts

default: build

help:
	@echo "The Mire End Cycle — build system"
	@echo ""
	@echo "First-time setup:"
	@echo "  make install-fonts  Install bundled fonts to ~/.fonts (run once)"
	@echo ""
	@echo "Targets:"
	@echo "  build              Build PRODUCT (default: $(PRODUCT))"
	@echo "  all                Build every product"
	@echo "  list               List available products"
	@echo "  watch              Rebuild on changes (needs 'entr')"
	@echo "  clean              Remove build artifacts"
	@echo "  check              Verify pandoc + xelatex are installed"
	@echo ""
	@echo "Override the product:"
	@echo "  make build PRODUCT=02-the-drowned-belfry"

install-fonts:
	@mkdir -p ~/.fonts
	@cp shared/fonts/*.ttf ~/.fonts/
	@fc-cache -f
	@echo "✓ Installed IM Fell English to ~/.fonts/"
	@fc-list | grep -i "fell" | head -3

check:
	@command -v $(PANDOC) >/dev/null 2>&1 || { echo "ERROR: pandoc not installed. See README."; exit 1; }
	@command -v $(PDF_ENGINE) >/dev/null 2>&1 || { echo "ERROR: $(PDF_ENGINE) not installed. See README."; exit 1; }
	@fc-list | grep -qi "EB Garamond" || { echo "WARNING: EB Garamond font not found. See README."; exit 1; }
	@fc-list | grep -qi "IM FELL English" || { echo "ERROR: IM Fell English not installed. Run: make install-fonts"; exit 1; }
	@echo "✓ pandoc:    $$($(PANDOC) --version | head -1)"
	@echo "✓ $(PDF_ENGINE):   $$($(PDF_ENGINE) --version | head -1)"
	@echo "✓ EB Garamond installed"
	@echo "✓ IM Fell English installed"

list:
	@echo "Products:"
	@for d in products/*/; do \
		name=$$(basename "$$d"); \
		title=$$(grep -E '^title:' "$$d/metadata.yaml" 2>/dev/null | sed 's/title: *//; s/"//g'); \
		printf "  %-32s %s\n" "$$name" "$$title"; \
	done

build: check
	@test -f $(MANUSCRIPT) || { echo "ERROR: $(MANUSCRIPT) not found"; exit 1; }
	@test -f $(METADATA)   || { echo "ERROR: $(METADATA) not found"; exit 1; }
	@mkdir -p $(BUILD_DIR)
	@echo "→ Building $(PRODUCT)..."
	@cp shared/fonts/*.ttf $(BUILD_DIR)/
	@$(PANDOC) \
		$(MANUSCRIPT) \
		--from=markdown+smart+yaml_metadata_block \
		--metadata-file=$(METADATA) \
		--template=$(TEMPLATE) \
		--top-level-division=section \
		-o $(BUILD_DIR)/$(PRODUCT).tex
	@cd $(BUILD_DIR) && $(PDF_ENGINE) -interaction=batchmode $(PRODUCT).tex >/dev/null 2>&1; true
	@cd $(BUILD_DIR) && $(PDF_ENGINE) -interaction=batchmode $(PRODUCT).tex >/dev/null 2>&1; true
	@test -f $(OUTPUT_PDF) || { \
		echo "✗ Build failed. Last errors from log:"; \
		grep -E '^!|fatal' $(BUILD_DIR)/$(PRODUCT).log | head -10; \
		exit 1; \
	}
	@rm -f $(BUILD_DIR)/*.ttf $(BUILD_DIR)/*.aux $(BUILD_DIR)/*.out
	@echo "✓ Built: $(OUTPUT_PDF)"
	@echo "  Size:  $$(du -h $(OUTPUT_PDF) | cut -f1)"
	@command -v pdfinfo >/dev/null 2>&1 && echo "  Pages: $$(pdfinfo $(OUTPUT_PDF) | grep Pages | awk '{print $$2}')" || true
	@warnings=$$(grep -c "^! " $(BUILD_DIR)/$(PRODUCT).log 2>/dev/null | tr -d '\n' || echo 0); \
		if [ "$$warnings" != "0" ] && [ -n "$$warnings" ]; then \
			echo "  ⚠  $$warnings LaTeX warnings (see $(BUILD_DIR)/$(PRODUCT).log)"; \
		fi

all:
	@for d in products/*/; do \
		name=$$(basename "$$d"); \
		$(MAKE) build PRODUCT=$$name || exit 1; \
	done

watch:
	@command -v entr >/dev/null 2>&1 || { echo "Install 'entr' (apt install entr / brew install entr)"; exit 1; }
	@echo "Watching $(MANUSCRIPT) for changes..."
	@echo "$(MANUSCRIPT) $(METADATA) $(TEMPLATE)" | tr ' ' '\n' | entr -c $(MAKE) build PRODUCT=$(PRODUCT)

clean:
	@rm -rf products/*/build/
	@echo "✓ Cleaned all build artifacts"
