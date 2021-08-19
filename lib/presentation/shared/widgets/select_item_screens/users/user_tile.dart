part of 'select_user_screen.dart';

class _UserTile extends StatelessWidget {
  const _UserTile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final PortalUser user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.back(
        result: {
          'id': user.id,
          'displayName': user.displayName,
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.5),
        child: Row(
          children: [
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CustomNetworkImage(
                height: 40,
                width: 40,
                image: user.avatar ?? user.avatarMedium ?? user.avatarSmall,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.displayName,
                    style: TextStyleHelper.projectTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  if (user.title != null)
                    Text(
                      user.title,
                      style: TextStyleHelper.projectResponsible,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
