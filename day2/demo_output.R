png(filename = "one_to_ten.png", width = 800, height = 800, res = 100)
plot(1:10)
dev.off()


png(filename = "one_to_ten.png", width = 210, height = 297, units = "mm", res = 600)
plot(1:10)
dev.off()

pdf(file = "one_to_ten.pdf", width = 8.25, height = 11-3/4210)
plot(1:10)
dev.off()
