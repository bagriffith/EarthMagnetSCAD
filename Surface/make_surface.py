import matplotlib.pyplot as plt

import cartopy.crs as ccrs
import cartopy.feature as cfeature


def main():
    for h, p in {'n': 90.0, 's': -90.0}.items():
        fig = plt.figure(figsize=(10, 10))

        ax = fig.add_subplot(1, 1, 1,
                             projection=ccrs.Stereographic(central_latitude=p,
                                                           scale_factor=3.9))
        ax.axis('off')
        plt.subplots_adjust(left=0, right=1, top=1, bottom=0,
                            wspace=0, hspace=0)

        land = cfeature.LAND.with_scale('110m')
        
        simplified_land = [x.simplify(0.5) for x in land.geometries()
                        if x.area > 5]
        ax.add_geometries(simplified_land, facecolor='k', crs=land.crs)
        fig.savefig(f'stereographic-{h}.svg', transparent=True, dpi=96)


if __name__ == '__main__':
    main()
