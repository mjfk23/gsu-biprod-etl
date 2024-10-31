<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command\Oracle;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;

#[AsCommand('oracle:sqlldr')]
final class SqlLoader extends Oracle
{
    /** @inheritdoc */
    protected function configure(): void
    {
        parent::configure();
        $this->addArgument('par_file', InputArgument::REQUIRED, 'Path to parameters file');
        $this->addArgument('data_file', InputArgument::REQUIRED, 'Path to data file');
    }


    /** @inheritdoc */
    protected function getShellArgs(InputInterface $input): array
    {
        /** @var string $database */
        $database = $input->getOption('database');
        /** @var string $parFile */
        $parFile = $input->getArgument('par_file');
        /** @var string $dataFile */
        $dataFile = $input->getArgument('data_file');

        return [
            ['sqlldr', "USERID={$database}", "PARFILE={$parFile}", "DATA={$dataFile}"]
        ];
    }
}
