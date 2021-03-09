/*
 * AMCC Kilauea USB-OTG wrapper
 *
 * Copyright 2008 DENX Software Engineering, Stefan Roese <sr@denx.de>
 *
 * Extract the resources (MEM & IRQ) from the dts file and put them
 * into the platform-device struct for usage in the platform-device
 * USB-OTG driver.
 *
 */

#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/of_platform.h>
#include <linux/of_address.h>
#include <linux/of_irq.h>

/*
 * Resource template will be filled dynamically with the values
 * extracted from the dts file
 */
static struct resource usb_otg_resources[] = {
	[0] = {
		/* 405EX USB-OTG registers */
		.flags  = IORESOURCE_MEM,
	},
	[1] = {
		/* 405EX OTG IRQ */
		.flags  = IORESOURCE_IRQ,
	},
	[2] = {
		/* High-Power workaround IRQ */
		.flags  = IORESOURCE_IRQ,
	},
	[3] = {
		/* 405EX DMA IRQ */
		.flags  = IORESOURCE_IRQ,
	},
};

static u64 dma_mask = 0xffffffffULL;

static struct platform_device usb_otg_device = {
        .name = "dwc_otg",
        .id = 0,
        .num_resources = ARRAY_SIZE(usb_otg_resources),
        .resource = usb_otg_resources,
        .dev = {
                .dma_mask = &dma_mask,
                .coherent_dma_mask = 0xffffffffULL,
        }
};

static struct platform_device *ppc405ex_devs[] = {
        &usb_otg_device,
};

static int ppc405ex_usb_otg_probe(struct platform_device *ofdev)
{
	struct device_node *np = ofdev->dev.of_node;
	struct resource res;

	/*
	 * Extract register address reange from device tree and put it into
	 * the platform device structure
	 */
	if (of_address_to_resource(np, 0, &res)) {
		printk(KERN_ERR "%s: Can't get USB-OTG register address\n", __func__);
		return -ENOMEM;
	}
	usb_otg_resources[0].start = res.start;
	usb_otg_resources[0].end = res.end;

	/*
	 * Extract IRQ number(s) from device tree and put them into
	 * the platform device structure
	 */
	usb_otg_resources[1].start = usb_otg_resources[1].end =
		irq_of_parse_and_map(np, 0);
	usb_otg_resources[2].start = usb_otg_resources[2].end =
		irq_of_parse_and_map(np, 1);
	usb_otg_resources[3].start = usb_otg_resources[3].end =
		irq_of_parse_and_map(np, 2);

	return platform_add_devices(ppc405ex_devs, ARRAY_SIZE(ppc405ex_devs));
}

static int ppc405ex_usb_otg_remove(struct platform_device *ofdev)
{
	/* Nothing to do here */
	return 0;
}

static const struct of_device_id ppc405ex_usb_otg_match[] = {
	{ .compatible = "amcc,usb-otg-405ex", },
	{ .compatible = "amcc,dwc-otg", },
	{ .compatible = "amcc,dwc_otg", },
	{ .compatible = "snps,dwc2", },
	{}
};

static struct platform_driver ppc405ex_usb_otg_driver = {
	.driver = {
		.name = "ppc405ex-usb-otg",
		.owner = THIS_MODULE,
		.of_match_table = ppc405ex_usb_otg_match,
	},
	.probe = ppc405ex_usb_otg_probe,
	.remove = ppc405ex_usb_otg_remove,
};

module_platform_driver(ppc405ex_usb_otg_driver);

MODULE_DESCRIPTION("OBS600 DWC_OTG Glue");
/* MODULE_AUTHOR("Matthijs Kooijman <matthijs@stdin.nl>"); */
MODULE_LICENSE("GPL");
