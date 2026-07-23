import 'package:flutter/material.dart';

import '../../avatar/vm_avatar.dart';
import '../../card/vm_card.dart';
import '../../list_item/vm_list_item.dart';
import '../gallery_widgets.dart';

/// Surfaces tab: structural/content containers. No Cubit state — specific
/// to this arrangement, but doesn't coordinate anything dynamic.
class SurfacesSection extends StatelessWidget {
  const SurfacesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GalleryCategory(
      demos: [
        GalleryDemo(
          label: 'Card',
          child: VmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card title',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text('Soft shadow, rounded corners, no glass effect.'),
              ],
            ),
          ),
        ),
        GalleryDemo(
          label: 'List item',
          child: VmCard(
            padding: EdgeInsets.zero,
            child: VmListItem(
              leading: const VmAvatar(image: AssetImage('assets/none.png')),
              title: const Text('Article title'),
              subtitle: const Text('Published today'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
