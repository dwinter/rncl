#
# --- Test readNCL.R ---
#

### Get all the test files
if (Sys.getenv("RCMDCHECK") == FALSE) {
    pth <- file.path(getwd(), "..", "inst", "nexusfiles")
} else {
    pth <- system.file(package="rncl", "nexusfiles")
}

if (Sys.getenv("RCMDCHECK") == FALSE) {
    pth_nw_good <- file.path(getwd(), "..", "inst", "newick_good")
} else {
    pth_nw_good <- system.file(package="rncl", "newick_good")
}


## co1.nex -- typical output from MrBayes. Contains 2 identical trees, the first
## one having posterior probabilities as node labels
co1File <- file.path(pth, "co1.nex")

## MultiLineTrees.nex -- 2 identical trees stored on several lines
multiLinesFile <- file.path(pth, "MultiLineTrees.nex")

## Newick trees
newick <- file.path(pth, "newick.tre")

## Contains correct (as of 2014-11-29) phylo representation of one of the tree
## stored in the nexus file
mlFile <- file.path(pth, "multiLines.rds")


stopifnot(file.exists(co1File))
stopifnot(file.exists(multiLinesFile))
stopifnot(file.exists(mlFile))


## function (file, simplify=TRUE, type=c("all", "tree", "data"),
##   char.all=FALSE, polymorphic.convert=TRUE, levels.uniform=TRUE,
##   check.node.labels=c("keep", "drop", "asdata"))



## ########### CO1 -- MrBayes file -- tree only

## Tree properties
## Labels
labCo1 <- c("Cow", "Seal", "Carp", "Loach", "Frog", "Chicken", "Human",
            "Mouse", "Rat", "Whale") #, NA, NA, NA, NA, NA, NA, NA, NA)
#names(labCo1) <- 1:18
## Edge lengths
eLco1 <- c(0.143336, 0.225087, 0.047441, 0.055934, 0.124549, 0.204809, 0.073060, 0.194575,
           0.171296, 0.222039, 0.237101, 0.546258, 0.533183, 0.154442, 0.134574, 0.113163,
           0.145592)
names(eLco1) <- c("11-1", "11-2", "11-12", "12-13", "13-14", "14-15", "15-16", "16-17", "17-3",
                  "17-4", "16-5", "15-6", "14-7", "13-18", "18-8", "18-9", "12-10")
## Node types
nTco1 <-  c("tip", "tip", "tip", "tip", "tip", "tip", "tip", "tip", "tip",
            "tip", "internal", "internal", "internal", "internal", "internal",
            "internal", "internal", "internal")
names(nTco1) <- 1:18
## Label values
lVco1 <- c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.93, 0.88, 0.99, 1.00,
           0.76, 1.00, 1.00)


context("rncl can deal with simple NEXUS files (tree only)")
test_that("file with 2 trees (warning normal)", {
    ## Read trees
    co1 <- read_nexus_phylo(file=co1File)
    ## Tree 1
    co1Tree1 <- co1[[1]]
    target_edgeLength <- unname(eLco1[paste(co1Tree1$edge[,1], co1Tree1$edge[,2], sep="-")])
    expect_equal(co1Tree1$tip.label, labCo1)     # check labels
    expect_equal(co1Tree1$edge.length, target_edgeLength)  # check edge lengths
    expect_equal(co1Tree1$node.label, c("", "0.93", "0.88", "0.99", "1.00", "0.76", "1.00", "1.00"))
    ## Tree 2
    co1Tree2 <- co1[[2]]
    expect_equal(co1Tree2$tip.label, labCo1)     # check labels
    expect_equal(co1Tree2$edge.length, target_edgeLength)  # check edge lengths
    expect_equal(co1Tree2$node.label, NULL)
})

test_that("test option simplify", {
    ## Check option simplify
    co1 <- read_nexus_phylo(file=co1File, simplify=TRUE)
    target_edgeLength <- unname(eLco1[paste(co1$edge[,1], co1$edge[,2], sep="-")])
    expect_true(inherits(co1, "phylo"))        # make sure there is only one tree
    expect_equal(co1$tip.label, labCo1)     # check labels
    expect_equal(co1$edge.length, target_edgeLength)  # check edge lengths
    expect_equal(co1$node.label, c("", "0.93", "0.88", "0.99", "1.00", "0.76", "1.00", "1.00"))
})

test_that("readNCL can handle multi line files", {
    ## ########### Mutli Lines -- tree only
    multiLines <- read_nexus_phylo(file=multiLinesFile)
    ## load correct representation and make sure that the trees read
    ## match it
    ml <- readRDS(mlFile)
    expect_equal(multiLines[[1]], ml[[1]])
    expect_equal(multiLines[[2]], ml[[2]])
    rm(ml)
})

## ########### Newick files
context("test with Newick files")
## Tree representation
labNew <- c("a", "b", "c")
eLnew <- c(1, 2, 3, 4)

test_that("check.node.labels='drop' with readNCL", {
    newTr <- read_newick_phylo(file=newick)
    expect_equal(newTr$tip.label, labNew)
    expect_equal(newTr$edge.length, eLnew)
    expect_equal(newTr$node.label, c("yy", "xx"))
})

## weird files
test_that("weird files",{
    tr <- read_newick_phylo(file=file.path(pth_nw_good, "Gudrun.tre"))
    expect_equal(length(tr$tip.label), 68)
    expect_equal(tr$Nnode, 42)
    simple_tree <- read_newick_phylo(file=file.path(pth_nw_good, "simpleTree.tre"))
    expect_equal(simple_tree$tip.label, c("A_1", "B__2", "C", "D"))
    expect_equal(simple_tree$node.label, c("mammals", "cats", "dogs"))
    sing_tree <- read_newick_phylo(file=file.path(pth_nw_good, "singTree.tre"))
    expect_equal(sing_tree$tip.label, c("A", "B", "C", "D", "E"))
    expect_equal(sing_tree$node.label, c("life", "tetrapods", "dogs", "mammals"))
    tr1 <- read_newick_phylo(file=file.path(pth_nw_good, "tree1.tre"))
    expect_equal(tr1$tip.label, c("A", "B", "C", "D"))
    expect_equal(tr1$node.label, c("F", "E"))
    expect_equal(tr1$edge.length, seq(.1, .5, by=.1))
    tr2 <- read_newick_phylo(file=file.path(pth_nw_good, "tree2.tre"))
    expect_equal(tr2$tip.label, LETTERS[1:4])
    expect_equal(tr2$node.label, "E")
    expect_equal(tr2$Nnode, 1)
})

test_that("file with missing edge lengths (default behavior)", {
    expect_warning(tr <- read_newick_phylo(file = file.path(pth_nw_good, "missing_edge_lengths.tre")),
                   "All removed")
    expect_true(is.null(tr$edge.length))
})

test_that("file with missing edge lengths specify missing value", {
    expect_warning(tr <- read_newick_phylo(file = file.path(pth_nw_good, "missing_edge_lengths.tre"),
                                           missing_edge_length = -99),
                   "replaced by")
    expect_true(sum(tr$edge.length == -99) > 0)
})

test_that("missing_edge_length is a single numeric value", {
    expect_error(tr <- read_newick_phylo(file = file.path(pth_nw_good, "missing_edge_lengths.tre"),
                                           missing_edge_length = "test"),
                 "single numerical value")
    expect_error(tr <- read_newick_phylo(file = file.path(pth_nw_good, "missing_edge_lengths.tre"),
                                           missing_edge_length = c(0, 1)),
                 "single numerical value")
    expect_error(tr <- read_newick_phylo(file = file.path(pth_nw_good, "missing_edge_lengths.tre"),
                                           missing_edge_length = c(NA, 1)),
                 "single numerical value")
    expect_error(tr <- read_newick_phylo(file = file.path(pth_nw_good, "missing_edge_lengths.tre"),
                                           missing_edge_length = c(TRUE)),
                 "single numerical value")
})
