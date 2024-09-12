<?php

declare(strict_types=1);

namespace Gsu\Biprod\Factory;

use Gsu\Biprod\Entity\SSOUser;
use mjfk23\Framework\Factory\AbstractFactory;
use mjfk23\Framework\Factory\Cast;
use mjfk23\LDAP\DateFormat;

/**
 * @extends AbstractFactory<SSOUser>
 */
final class SSOUserFactory extends AbstractFactory
{
    public function __construct()
    {
        parent::__construct(SSOUser::class);
    }


    /** @inheritdoc */
    public function create(mixed $values): object
    {
        $values = Cast::toArray($values);
        $memberOf = Cast::toString($values['memberOf'] ?? '');
        return new SSOUser(
            campusId: Cast::toString($values['sAMAccountName'] ?? ''),
            emailAddress: Cast::toString($values['mail'] ?? ''),
            firstName: Cast::toString($values['givenName'] ?? ''),
            lastName: Cast::toString($values['sn'] ?? ''),
            affiliations: array_keys(array_filter(
                SSOUser::$AFFILIATIONS,
                fn(string $group): bool => str_contains($memberOf, $group)
            )),
            accountStatus: Cast::toInt($values['userAccountControl'] ?? 0),
            createDate: DateFormat::formatUTCTimestamp(Cast::toInt($values['whenCreated'] ?? 0)),
            updateDate: DateFormat::formatUTCTimestamp(Cast::toInt($values['whenChanged'] ?? 0)),
            pwdLastSet: DateFormat::formatTimeInterval(Cast::toInt($values['pwdLastSet'] ?? 0))
        );
    }
}
